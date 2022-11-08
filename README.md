# MyAWSOpsTools

A collection of my favorite AWS operation tools install and upgrade scripts.
在长期的AWS大规模账号环境运维过程中，需要用大很多必备或者常用的工具，可以帮助提高AWS的运维的效率。
尽管这些工具都非常常见，且多数都有良好的文档，但是当这个工具集数量逐渐变得越来越多以后，维护和配置这套运维工具栈本身也变成了一个耗时且枯燥的任务。因此我将各个工具的安装、升级脚本进行了整合，并且利用Github API为一些工具增加了自动检查升级版本的能力。这样，只要定期简单的执行这个脚本，就可以确保这一整套工具都随时保持最新的状态，帮助我们更好的使用AWS云服务。

使用提示：这套Shell脚本模板是在WSL2的Ubuntu环境中开发并使用的，其他Linux发行版和Shell环境可能有所不同，另外脚本中也有一些需要替换为符合您的环境和需要的变量，需要在使用前进行设置。

以下是脚本中涉及的一些工具的介绍和使用场景说明：
- conda
https://conda.io
conda是包、依赖以及运行环境管理的知名工具。
我主要是用来针对Python的包和依赖以及不同版本的Python运行环境进行管理。很多AWS工具都基于Python编写，但是不同的工具依赖包和环境的版本要求可能有冲突，使用conda可以很好的解决这个问题。

- terraform
- packer
- helm
- boto3
- awscli
- terraformer
- terragrunt
- infracost
- ecscli
- eksctl
- eksctl-anywhere
- awsvault
- steampipe
- pulumi
- cloudquery
- samcli
- pet
- just
