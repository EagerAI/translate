

install.packages(c('magrittr','glue'))
install.packages('remotes')
remotes::install_github('rstudio/reticulate')
reticulate::install_miniconda()
reticulate::py_install('git+https://github.com/huggingface/transformers.git',pip = TRUE)
reticulate::py_install('sentencepiece torch==1.7.1+cpu torchvision==0.8.2+cpu torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html',pip = TRUE)

library(magrittr)

# import
args = commandArgs(trailingOnly=TRUE) 
user = grep('predict',args,value = T)
# [1] "--issue_comment_body"   " /predict az_AZ en_XX Təşkilatçıların maddi rifahı naminə sayı 100 min izləyiciyə çatdıra bilmərik”, - deyə Fransanın mədəniyyət naziri bildirib." "--issue_number"        
# [4] "2"                      "--issue_user"           "henry090"    


args[4] -> issue_

gsub(trimws(user),pattern = '/predict ..... .....', replacement = '') %>% trimws() -> body__

substring(trimws(user),9,21) %>% trimws() %>% strsplit(.,' ') %>% unlist() -> from_to

args[6] -> user_


reticulate::py_run_string(
glue::glue('
from transformers import MBartForConditionalGeneration, MBart50TokenizerFast

article_az = "{body__}"

model = MBartForConditionalGeneration.from_pretrained("facebook/mbart-large-50-many-to-many-mmt")
tokenizer = MBart50TokenizerFast.from_pretrained("facebook/mbart-large-50-many-to-many-mmt")


# translate Azerbaijani to English
tokenizer.src_lang = "{from_to[1]}"
encoded_az = tokenizer(article_az, return_tensors="pt")
generated_tokens = model.generate(
    **encoded_az,
    forced_bos_token_id=tokenizer.lang_code_to_id["{from_to[2]}"]
)
output = tokenizer.batch_decode(generated_tokens, skip_special_tokens=True)
f= open("output.txt","w+")
f.write(", ".join(map(str, output)))
f.close()
                          ')
)

prob=paste(readLines("output.txt"), collapse=" ")

reply_message = glue::glue("Hey @{user_}!<br>This was your input: {body__}.<br>The is the prediction: **{prob}**")

reply_message = glue::glue('print(f"::set-output name=issue_comment_reply::{reply_message}")')

fileConn<-file("hello.py")
writeLines(reply_message, fileConn)
close(fileConn)












