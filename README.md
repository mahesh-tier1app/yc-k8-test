# yc-k8-test

## Setup

1. Clone repo: 

   ```sh
   SSH - git clone git@github.com:mahesh-tier1app/yc-k8-test.git
   HTTPS - git clone https://github.com/mahesh-tier1app/yc-k8-test.git
   
   cd yc-k8-test
   ```

2. Download `license.lic` and put it into this directory


## Docker Image

1. To build image:

   ```sh
   docker build -t ycrash .
   ```

2. To run the container locally:

   ```sh
   docker run -ti --rm -p 8080:8080 --name ycrash -v $(pwd)/license.lic:/opt/workspace/yc/license.lic ycrash
   ```

   Then open http://localhost:8080 

## Kubernetes

Kubernetes manifests (yaml) resides in `kubernetes/` directory.

1. Copy `kubernetes/secret.yaml.template` to `kubernetes/secret.yaml`

   ```
   cp kubernetes/secret.yaml.template secret.yaml
   ```

2. Edit `kubernetes/secret.yaml` and replace the license template with the real one.

3. Assuming you have a running kubernetes cluster and kubectl ready to access the cluster, next step is to just run:

   ```
   kubectl apply -f kubernetes -R
   ```

4. There are a few ways of exposing a service in kubernetes to the outside. But for the initial scope, we can access it privately with:

   ```
   kubectl port-forward svc/yc-web 8080:8080
   ```

5. Then the service should be accessible from http://localhost:8080


## Notes

- Kubernetes deployment yaml is working. It's the simplest implementation, which is easy for initial review but not yet "production ready".
