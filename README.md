# 🐳 Desafio Docker 02 — API Python

## 🎯 Objetivo

Containerizar uma API Python utilizando Flask e executá-la com Gunicorn.

Neste desafio, além dos conceitos básicos de Docker, foram praticados:

- Exposição de portas;
- Mapeamento de portas entre host e container;
- Variáveis de ambiente;
- Execução de aplicações com Gunicorn;
- Comunicação entre o computador host e o container.

---

## 📁 Estrutura do projeto

```text
desafio-docker-02-python-api/
├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── .gitignore
└── README.md
```

---

## 🐍 Aplicação

A aplicação foi desenvolvida utilizando Flask.

O endpoint `/` retorna o nome da aplicação e o ambiente configurado através de uma variável de ambiente.

Exemplo:

```json
{
    "application": "python-api",
    "environment": "production"
}
```

A variável é obtida no código através de:

```python
os.getenv("ENVIRONMENT", "development")
```

Caso a variável `ENVIRONMENT` não seja informada, o valor padrão utilizado é `development`.

---

## 📦 Dependências

O projeto utiliza:

```text
Flask==3.1.0
gunicorn==23.0.0
```

As dependências são instaladas durante a criação da imagem Docker.

---

## 🐳 Dockerfile

O Dockerfile utiliza a imagem oficial:

```dockerfile
FROM python:3.12-slim
```

O diretório de trabalho dentro do container é:

```dockerfile
WORKDIR /app
```

As dependências são copiadas e instaladas antes do restante da aplicação:

```dockerfile
COPY ./requirements.txt /app/

RUN pip install -r ./requirements.txt
```

Depois, os arquivos da aplicação são copiados:

```dockerfile
COPY . /app/
```

A aplicação utiliza a porta `8000` dentro do container:

```dockerfile
EXPOSE 8000
```

A aplicação é iniciada utilizando Gunicorn:

```dockerfile
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
```

---

## 🔨 Build da imagem

Para criar a imagem:

```bash
docker build -t apipython .
```

A imagem criada recebe o nome:

```text
apipython
```

---

## ▶️ Executando o container

Como já existe uma aplicação Django utilizando a porta `8000` no computador host, a API foi disponibilizada na porta `8008` do host.

```bash
docker run -p 8008:8000 -e ENVIRONMENT=production apipython:latest
```

O mapeamento utilizado é:

```text
-p 8008:8000
```

Onde:

- `8008` → porta do computador host;
- `8000` → porta utilizada pela aplicação dentro do container.

Dessa forma:

```text
Mac
localhost:8008
       │
       ▼
Container
0.0.0.0:8000
       │
       ▼
Gunicorn
```

A API pode ser acessada em:

```text
http://localhost:8008
```

---

## 🌎 Variáveis de ambiente

A variável `ENVIRONMENT` é passada durante a execução do container:

```bash
-e ENVIRONMENT=production
```

Também é possível utilizar outros valores:

```bash
-e ENVIRONMENT=homolog
```

ou:

```bash
-e ENVIRONMENT=development
```

O valor recebido pelo container é disponibilizado para a aplicação através da variável de ambiente:

```python
os.getenv("ENVIRONMENT")
```

Também é possível utilizar um arquivo `.env` com:

```bash
docker run --env-file .env -p 8008:8000 apipython:latest
```

O arquivo `.env` não é incluído no repositório.

---

## 🔌 Portas

Um dos principais aprendizados deste desafio foi entender a diferença entre a porta do **host** e a porta do **container**.

O comando:

```bash
docker run -p 8008:8000 ...
```

segue o formato:

```text
-p PORTA_DO_HOST:PORTA_DO_CONTAINER
```

Portanto:

```text
8008 → Mac
8000 → Container
```

A porta `8000` pode continuar sendo utilizada pelo Django local, pois o Django está rodando diretamente no Mac e não dentro desse container.

A API Docker fica disponível em:

```text
localhost:8008
```

enquanto o Gunicorn permanece escutando em:

```text
0.0.0.0:8000
```

---

## 📚 Conceitos praticados

### Docker

- `FROM`
- `WORKDIR`
- `COPY`
- `RUN`
- `EXPOSE`
- `CMD`
- `docker build`
- `docker run`
- Tags de imagens

### Execução de containers

- Mapeamento de portas com `-p`;
- Variáveis de ambiente com `-e`;
- Uso de `--env-file`;
- Diferença entre host e container.

### Python

- Flask;
- Gunicorn;
- Variáveis de ambiente com `os.getenv()`.

---

## 🧠 Principais aprendizados

### 1. `EXPOSE` não publica a porta

O `EXPOSE` apenas informa/documenta a porta utilizada pela aplicação dentro da imagem.

Quem cria o acesso entre o host e o container é o `-p`:

```bash
-p 8008:8000
```

### 2. As portas não precisam ser iguais

É possível utilizar:

```text
Host:      8008
Container: 8000
```

ou:

```text
Host:      8008
Container: 8008
```

O importante é que o Gunicorn esteja escutando na porta correta dentro do container e que o mapeamento do `-p` corresponda a ela.

### 3. `0.0.0.0` é importante no container

O Gunicorn foi configurado para:

```text
0.0.0.0:8000
```

Isso permite que a aplicação aceite conexões vindas de fora do container.

### 4. Variáveis de ambiente podem ser fornecidas no momento da execução

Exemplo:

```bash
-e ENVIRONMENT=production
```

Isso permite alterar configurações sem precisar criar uma nova imagem.

---

## ✅ Resultado

A API Python foi containerizada e executada com sucesso utilizando:

- Python 3.12;
- Flask;
- Gunicorn;
- Docker;
- variável de ambiente;
- mapeamento de porta entre host e container.

A aplicação ficou acessível através de:

```text
http://localhost:8008
```