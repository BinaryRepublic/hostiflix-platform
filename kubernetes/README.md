source: https://kubernetes.io/docs/concepts/configuration/secret/

### Creating a secret
```
echo -n 'admin' > ./username.txt
echo -n '1f2d1e2e67df' > ./password.txt
kubectl create secret generic mysecret --from-file=./username.txt --from-file=./password.txt

rm ./username.txt && rm ./password.txt
```

### Use as environment variable

```
env:
  - name: SECRET_USERNAME
    valueFrom:
      secretKeyRef:
        name: mysecret
        key: username
  - name: SECRET_PASSWORD
    valueFrom:
      secretKeyRef:
        name: mysecret
        key: password
```