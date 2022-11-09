# MyAWSOpsTools

A collection of my favorite AWS operation tools install and upgrade scripts.<br>
在长期的AWS大规模账号环境运维过程中，需要用大很多必备或者常用的工具，可以帮助提高AWS的运维的效率。 <br>
尽管这些工具都非常常见，且多数都有良好的文档，但是当这个工具集数量逐渐变得越来越多以后，我发现几乎每天都会有工具发布新的版本匹配AWS的服务更新、修复Bug和提供新的特性，维护和配置这套运维工具栈本身也变成了一个耗时且枯燥的任务。因此我将各个工具的安装、升级脚本进行了整合，并且利用Github API为一些工具增加了自动检查升级版本的能力。这样，只要定期简单的执行这个脚本，就可以确保这一整套工具都随时保持最新的状态，帮助我们更好的使用AWS云服务。

使用提示：这套Shell脚本模板是在WSL2的Ubuntu环境中开发并使用的，其他Linux发行版和Shell环境可能有所不同，另外脚本中也有一些需要替换为符合您的环境和需要的变量，需要在使用前进行设置。

以下是脚本中涉及的一些工具的介绍和使用场景说明：

- conda<br>
https://conda.io<br>
conda是包、依赖以及运行环境管理的知名工具。
我主要是用来针对Python的包和依赖以及不同版本的Python运行环境进行管理。很多AWS工具都基于Python编写，但是不同的工具依赖包和环境的版本要求可能有冲突，使用conda可以很好的解决这个问题。

- terraform<br>
https://www.terraform.io/<br>
terraform是IaC的必备工具，这里不做赘述。其aws的data属性可以轻松实现动态的云资源配置变更，其丰富的plugin资源使得跨堆栈实现复杂的IaC逻辑成为可能。

- packer<br>
https://www.packer.io/<br>
packer是制作运维AMI镜像的利器，可以应用于系统安全加固、软件包版本更新、为EKS、EMR等提供自定义镜像等场景中。

- helm<br>
https://helm.sh/<br>
Helm是Kubernetes的包管理器，可以帮助在EKS环境中部署应用，其依赖管理、版本管理在大规模分发容器应用时将很有帮助，很多知名的软件包都提供了helm的部署方式。

- boto3<br>
https://aws.amazon.com/sdk-for-python<br>
AWS SDK for Python，用于开发自动化运维工具

- awscli<br>
https://aws.amazon.com/cli/<br>
和IaC等其他自动化方式相比，cli提供了快速简便的进行一些即时或临时运维操作的途径，配合Shell脚本以及awscli的skeleton和input file特性，awscli甚至也可以完成类似IaC和自动化的运维场景，因此很多时候我会利用awscli进行aws API测试以及快速概念验证的工作。

- terraformer<br>
https://github.com/GoogleCloudPlatform/terraformer<br>
terraformer是一个terraform逆向工程工具，可以从已有的云资源生成terraform模板

- terragrunt<br>
https://terragrunt.gruntwork.io/<br>
terragrunt是一个terraform的wrapper，提供了一些附加工具帮助格式化terraform模板和对state进行管理。

- infracost<br>
https://www.infracost.io/<br>
正如其名，infracost可以基于terraform模板提供部署后的资源成本估算，并可以很容易的集成到CICD pipeline中，是FinOps和良好架构的有力工具。

- ecscli<br>
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-developer-tools.html<br>
ecscli是ECS服务的命令行工具，可以对ECS资源进行创建、读取、更新和删除等操作。 

- eksctl<br>
https://eksctl.io/<br>
eksctl是EKS的命令行工具，用于创建和管理EKS集群。

- eksctl-anywhere<br>
https://eksctl.io/usage/eksctl-anywhere/<br>
eksctl-anywhere是eksctl的扩展，专门用于EKS anywhere集群的创建和管理。

- awsvault<br>
https://github.com/99designs/aws-vault<br>
aws-vault是在开发运维环境中安全的存储AWS安全凭据的工具，我在AWS运维工作中使用这一工具管理上百个account的登录凭据，管理MFA，Assume Role和获取临时凭据，以确保运维过程中的安全。

- steampipe<br>
https://steampipe.io/<br>
steampipe是一个强大的云CMDB工具，可以使用标准SQL语句对AWS中的云资源进行实时或准实时查询，同时提供了API，PostgreSQL数据接口可以方便的与其他系统进行集成，steampipe社区也提供了很多安全、成本优化等control和benchmark帮助优化管理AWS环境。

- pulumi<br>
https://www.pulumi.com<br>
pulumi是另一个IaC工具，与CDK类似，可以使用JavaScript, Go等通用语言进行IaC模板的编写。

- cloudquery<br>
https://www.cloudquery.io/<br>
cloudquery是另一个云资源信息收集和CMDB工具，与steampipe的设计有所不同，cloudquery基于定期扫描的异步机制，但是

- samcli<br>
https://aws.amazon.com/serverless/sam/<br>
AWS Serverless Application Model是必备的Lambda开发框架，提供了强大的调试、打包、部署、更新Lambda的工具，我们基于Lambda的运维自动化开发都是基于SAM进行的。

- pet<br>
https://github.com/knqyf263/pet<br>
pet是Shell命令行脚本代码片段管理工具，用于简化运维工作中的通用命令行操作。

- just<br>
https://github.com/casey/just<br>
just是另一个Shell命令行脚本代码片段管理工具，与pet不同，just可以以project的组织形式对Shell脚本进行管理，这样在多个客户和项目的环境中更为实用。
