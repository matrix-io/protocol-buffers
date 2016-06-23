# Cross app protocol buffers
This repo contains all protocol buffers currently defined for inter application communication. Applications interested in using protocol buffers should `git submodule` this repo preferably inside a folder called `protos`. 

## Keep in mind ..
Protocol buffers are meant to be backwards compatible, so make sure any changes you do, are in fact backwards compatible. 

Changes done here impact many applications that use the protos, make sure you create a **pull request** with your changes and you reference all relevant reviewers (MALOS, MatrixOS, detection server, teams).   

You should always keep your application compatible with the latest version of the protocol buffers, so make sure you run `git submodule update --remote` the protocol buffer submodule, or `git pull origin master` inside the submodule.  

