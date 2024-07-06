# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias llm='ls -lp|more'
alias lt='ls -lt'
alias ltm='ls -lt|more'
alias s='source'
alias m='more'
alias hi='history'
alias psall='ps uax|sort|more'

#Kubernetes
alias kube-nodes='kubectl get nodes -o wide'
alias kube-pods=' kubectl get pods --all-namespaces -o wide'
alias kube-svc='kubectl get svc --all-namespaces -o wide'
alias kube-top-nodes='kubectl top nodes'
alias kube-top-pods='kubectl top pods -A --containers --sum'