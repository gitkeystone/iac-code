## Secret
```bash
kubectl create secret \
        generic aws-secret \
        -n crossplane-system \
        --from-file=creds=./aws-credentials.txt
```