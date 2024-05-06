# Dockerfile you need: Dockerfile

## BUILD it RUN it


```
docker build -t docker-image:tag -f Dockerfile .

docker run --privileged -it -e GITHUB_PERSONAL_TOKEN="<github-personal-access-token>" -e GITHUB_OWNER="<organization-name>" -e RUNNER_NAME="runner-name" docker-image:tag

```

## change `runs-on` in workflow

```yaml
runs-on: self-hosted 

# or

runs-on: runner-name 
```