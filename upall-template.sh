# NOTE: 执行前设置环境变量开代理
sudopass="bluebird"
echo "# apt:"
echo $sudopass | sudo -S apt update
sudo apt upgrade -y
sudo apt autoremove
sudo apt autoclean
# 根据需要进行虚拟环境的升级
echo "# conda:"
conda update conda -y
conda update --all -y
# <Replace with your own envs>
conda update -n py27 --all -y
conda update -n py39 --all -y

# terraform通过apt安装升级：https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform
# packer通过apt安装升级：https://www.packer.io/downloads
# helm通过apt安装升级：https://helm.sh/docs/intro/install/#from-apt-debianubuntu

binpath="<YOUR bin path>"

# GitHub Token setting, resolve GitHub API invoke rate limit
githubusername="<YOUR GitHub username>"
githubtoken="<YOUR GitHub token>"

#通过空tf模板更新常用的terraform plugin
echo "# terraform plugins:"
terraform init -upgrade

#更新pip
python3 -m pip install --upgrade pip

#更新boto3
echo "# boto3:"
pip install --upgrade boto3

echo "# awscli:"
awscli_v=$(aws --version | grep -o -P "(?<=aws-cli\/)\d{1,}\.\d{1,}\.\d{1,}")
awscli_latestv=$(curl -silent https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst | grep -o -m 1 -P "\d{1,}\.\d{1,}\.\d{1,}")
if [ "$awscli_v" != "$awscli_latestv" ] && [ "$awscli_latestv" != null ]; then
	echo "awscli:v${awscli_v}->v${awscli_latestv}"
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${awscli_latestv}.zip" -o "awscliv2.zip"
	unzip -o -q awscliv2.zip
	sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
	aws --version
fi

echo "# terraformer:"
terraformer_v=$(terraformer version | grep -o -P "(?<=Terraformer )v\d{1,}\.\d{1,}\.\d{1,}")
terraformer_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | jq -r ".tag_name")
if [ "${terraformer_v}" != "v${terraformer_latestv}" ] && [ "${terraformer_latestv}" != null ]; then
	echo "terraformer:${terraformer_v}->v${terraformer_latestv}"
	export PROVIDER=aws
	curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s -u {githubusername}:{githubtoken} https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64
	chmod u+x terraformer-${PROVIDER}-linux-amd64
	mv "./terraformer-${PROVIDER}-linux-amd64" "${binpath}/terraformer"
	terraformer version
fi

echo "# terragrunt:"
terragrunt_v=$(terragrunt --version | grep -o -P "(?<=terragrunt version )v\d{1,}\.\d{1,}\.\d{1,}")
terragrunt_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq -r ".tag_name")
if [ "${terragrunt_v}" != "$terragrunt_latestv" ] && [ "$terragrunt_latestv" != null ]; then
	echo "terragrunt:${terragrunt_v}->${terragrunt_latestv}"
	curl -o "${binpath}/terragrunt" --location "https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_$(uname -s)_amd64"
	chmod u+x "${binpath}/terragrunt"
	terragrunt version
fi

echo "# infracost:"
infracost_v=$(infracost --version | grep -o -P "(?<=Infracost )v\d{1,}\.\d{1,}\.\d{1,}")
infracost_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/infracost/infracost/releases/latest | jq -r ".tag_name")
if [ "$infracost_v" != "$infracost_latestv" ] && [ "$infracost_latestv" != null ]; then
	echo "infracost:${infracost_v}->${infracost_latestv}"
	curl --location "https://github.com/infracost/infracost/releases/download/${infracost_latestv}/infracost-$(uname -s)-amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/infracost-linux-amd64 "${binpath}/infracost"
	infracost --version
fi

echo "# ecscli:"
ecscli_v=$(ecs-cli --version | grep -o -P "(?<=ecs-cli version )\d{1,}\.\d{1,}\.\d{1,}")
ecscli_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/aws/amazon-ecs-cli/releases/latest | jq -r ".tag_name")
if [ "v${ecscli_v}" != "$ecscli_latestv" ] && [ "$ecscli_latestv" != null ]; then
	echo "ecscli:v${ecscli_v}->${ecscli_latestv}"
	curl -Lo "${binpath}/ecs-cli" --location "https://amazon-ecs-cli.s3.cn-north-1.amazonaws.com.cn/ecs-cli-linux-amd64-latest"
	ecs-cli --version
fi

echo "# eksctl:"
eksctl_v=$(eksctl version)
eksctl_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/weaveworks/eksctl/releases/latest | jq -r ".tag_name")
if [ "v${eksctl_v}" != "$eksctl_latestv" ] && [ "$eksctl_latestv" != null ]; then
	echo "eksctl:v${eksctl_v}->${eksctl_latestv}"
	curl --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/eksctl $binpath
	eksctl version
fi

echo "# eksctl-anywhere:"
export EKSA_RELEASE="0.11.1" OS="$(uname -s | tr A-Z a-z)" RELEASE_NUMBER=17
curl "https://anywhere-assets.eks.amazonaws.com/releases/eks-a/${RELEASE_NUMBER}/artifacts/eks-a/v${EKSA_RELEASE}/${OS}/amd64/eksctl-anywhere-v${EKSA_RELEASE}-${OS}-amd64.tar.gz" \
    --silent --location \
    | tar xz ./eksctl-anywhere
sudo mv ./eksctl-anywhere /usr/local/bin/

echo "# awsvault:"
awsvault_v=$(aws-vault --version 2>&1)
awsvault_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/99designs/aws-vault/releases/latest | jq -r ".tag_name")
if [ "$awsvault_v" != "$awsvault_latestv" ] && [ "$awsvault_latestv" != null ]; then
	echo "aws-vault:${awsvault_v}->${awsvault_latestv}"
	curl -o "${binpath}/aws-vault" --location "https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-$(uname -s)-amd64"
	aws-vault --version
fi

echo "# steampipe:"
steampipe_v=$(steampipe -v | grep -o -P "\d{1,}\.\d{1,}\.\d{1,}")
steampipe_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/turbot/steampipe/releases/latest | jq -r ".tag_name")
if [ "v${steampipe_v}" != "$steampipe_latestv" ] && [ "$steampipe_latestv" != null ]; then
	echo "steampipe:v${steampipe_v}->${steampipe_latestv}"
	sudo /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)"
	steampipe -v
fi
# NOTE: plugin安装更新需要开全局代理
steampipe plugin update --all

echo "# pulumi:"
pulumi_v=$(pulumi version)
# github release与stable version不一致
# pulumi_latestv=$(curl -sL https://api.github.com/repos/pulumi/pulumi/releases/latest | jq -r ".tag_name")
pulumi_latestv=$(curl -sL https://www.pulumi.com/docs/get-started/install/versions/ | grep -o -P "(?<=The current stable version of Pulumi is <strong>)\d{1,}\.\d{1,}\.\d{1,}")
if [ "$pulumi_v" != "v${pulumi_latestv}" ]; then
	echo "pulumi:${pulumi_v}->v${pulumi_latestv}"
	curl -fsSL https://get.pulumi.com | sh
	pulumi version
fi

echo "# cloudquery:"
#cloudquery_v=$(cloudquery version | grep -o -P "(?<=Version: )\d{1,}\.\d{1,}\.\d{1,}")
#cloudquery_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/cloudquery/cloudquery/tags | jq -r ".[0].name" | grep -o -P "v\d{1,}\.\d{1,}\.\d{1,}")
#if [ "v${cloudquery_v}" != "$cloudquery_latestv" ] && [ "$cloudquery_latestv" != null ]; then
#	echo "cloudquery:v${cloudquery_v}->${cloudquery_latestv}"
#	curl -L https://github.com/cloudquery/cloudquery/releases/download/cli/${cloudquery_latestv}/cloudquery_linux_x86_64 -o "${binpath}/cloudquery"
#	chmod a+x "${binpath}/cloudquery"
#	cloudquery version
#fi

echo "# samcli:"
samcli_v=$(sam --version | grep -o -P "(?<=SAM CLI, version )\d{1,}\.\d{1,}\.\d{1,}")
samcli_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/aws/aws-sam-cli/releases/latest | jq -r ".tag_name")
if [ "v${samcli_v}" != "$samcli_latestv" ] && [ "$samcli_latestv" != null ]; then
	echo "samcli:v${samcli_v}->${samcli_latestv}"
	curl "https://github.com/aws/aws-sam-cli/releases/download/${samcli_latestv}/aws-sam-cli-linux-x86_64.zip" -L -o "aws-sam-cli-linux-x86_64.zip"
	unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
	sudo ./sam-installation/install --update
	sam --version
fi

echo "# pet:"
pet_v=$(pet version | grep -o -P "(?<=pet version )\d{1,}\.\d{1,}\.\d{1,}")
pet_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/knqyf263/pet/releases/latest | jq -r ".tag_name")
if [ "v${pet_v}" != "$pet_latestv" ] && [ "$pet_latestv" != null ]; then
	echo "pet:v${pet_v}->${pet_latestv}"
	pet_latest=$(echo "$pet_latestv" | sed "s/v//")
	wget -q "https://github.com/knqyf263/pet/releases/download/${pet_latestv}/pet_${pet_latest}_linux_amd64.deb" -O pet.deb
	sudo dpkg -i pet.deb
	pet version
fi

echo "# just:"
just_v=$(just --version | grep -o -P "(?<=just )\d{1,}\.\d{1,}\.\d{1,}")
just_latestv=$(curl -sL -u {githubusername}:{githubtoken} https://api.github.com/repos/casey/just/releases/latest | jq -r ".tag_name")
if [ "${just_v}" != "$just_latestv" ] && [ "$just_latestv" != null ]; then
	echo "just:v${just_v}->${just_latestv}"
	curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to $binpath --force
	just --version
fi