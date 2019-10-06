
# push image to ECR
$ terraform apply
$ $(aws ecr get-login --no-include-email --region ap-northeast-1)

example:
$ docker build -t [image] .
$ docker tag [image]:latest [domain]/[image]:latest
$ docker push [domain]/[image]:latest

# register task definition
```bash
$ aws ecs register-task-definition \
    --cli-input-json file://task_definition.json \
    > register-task-definition.log
    

$ ecs-cli compose --file docker-compose.yml \
--ecs-params ecs-params.yml up

 --create-log-groups

ecs-cli \
    compose \
        --verbose \
        --file docker-compose.yml \
        --ecs-params ecs-params.yml \
        --region ap-northeast-1 \
        --cluster ls-test-staging \
     up

```
        

# Ref
[【AWS】初めてのECR - Qiita](https://qiita.com/3utama/items/b19e2239edb6996a735f)

- scheduled task: [terraform-ecs-fargate-scheduled-task/ecs.tf at master · turnerlabs/terraform-ecs-fargate-scheduled-task](https://github.com/turnerlabs/terraform-ecs-fargate-scheduled-task/blob/master/env/dev/ecs.tf)
