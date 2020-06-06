# Deploy

```bash
terraform apply -var netlify_token=$(cat token) -var server_name=$(ruby -rhaikunator -e 'print Haikunator.haikunate')
```
