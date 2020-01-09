#!/bin/bash

## Ref:
## How to read a file line by line
##  * https://stackoverflow.com/a/10929511
##  * https://stackoverflow.com/questions/10929453/read-a-file-line-by-line-assigning-the-value-to-a-variable?answertab=active#tab-top
##  Use IFS (internal field separator) tool in bash, defines the character using to separate lines into tokens, by default includes <tab> /<space> /<newLine>

function download_arxiv() {
  local dpath="/aimldl-kbank/downloads"
  local filename="arxiv.org.ids"

  if [ ! -f ${filename} ]; then
    echo "Error: Input ids file does not exists: ${filename}"
    return
  fi

  mkdir -p ${dpath}
  echo "Download path: ${dpath}"

  local line
  local waittime=10
  while IFA='' read -r line; do
    # echo "LINE: ${line}"
    # echo "https://arxiv.org/abs/${line}"
    echo "sleep for ${waittime} seconds..."
    echo "wget --user-agent='Mozilla' -c https://arxiv.org/pdf/${line}.pdf -P ${dpath}"
    local filepath=${dpath}/${line}.pdf
    if [ -f ${filepath} ]; then
      echo "Already exists: ${filepath}"
    else
      sleep ${waittime} && wget --user-agent="Mozilla" -c https://arxiv.org/pdf/${line}.pdf -P ${dpath}
    fi
    ls -ltr ${filepath}
  done < "${filename}"
}

download_arxiv
