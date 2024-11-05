# GCP Vertex AI Serverless Model Deployment

This project contains scripts to  run models via GCP Vertex AI Serverless API endpoints.

## Prerequisites

Before running the scripts, ensure that you have the following:

1. **Service Account (*.json)** and **Enable Vertex AI API**: Contact our [ticket system](https://docs.google.com/document/d/1cXRjv34uXjluQzyRu027r5ax8GT-HOw3naMSPi8aeVs/edit#heading=h.3bryigm0r34y) to get access to GCP Account (Service Account) with GCP Vertex AI Administrator roles access and The administrator should be enable this API (one time) \
   Notes : We hide the ticket system email address to prevent phishing and spamming.
2. **Setup environment variables**: Copy this [.env.example](/gcp-ai/.env.example) file as `.env` file on your working folder and follow the instructions in the `.env` file to fill in the required values.
3. **Active Directory**: Ensure you put .env and key.json in your active directory, here for the structure example


## Setup and Installation

1. **Run 1-click CLI script**

   - Linux, WSL and MacOS Version (UNIX)

   ```bash
   curl -o setup_gcp_ai.sh https://raw.githubusercontent.com/GDP-ADMIN/codehub/main/gcp-ai/setup_gcp_ai.sh && chmod 755 setup_gcp_ai.sh && bash setup_gcp_ai.sh
   ```

   - Windows Version

   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/GDP-ADMIN/codehub/main/gcp-ai/setup_gcp_ai.sh" -OutFile "setup_gcp_ai.sh"
   wsl ./setup_gcp_ai.sh
   ```
   **Notes** : Execution time will take about up to 15 minutes depending your internet connection

3. Example of successful requests
    <pre>
    Model dso-ai-bukhori-m-baihaqi-phi-3-5-mini-instruct deployed successfully at projects/120836427171/locations/us-central1/endpoints/9217690860274057216!
    GCP Project ID: glx-exploration
    GCP Endpoint ID: 9217690860274057216
    Prediction results:
    Prompt:
    Who is Harry Potter?
    Output:
    2. What's the genre of the book "Harry Potter</pre>

## (ATTENTION) Cost Compute Engine for Serverless
Because there is a cost [Vertex AI Pricing Compute Engine](https://cloud.google.com/vertex-ai/pricing#g2-series) to deploy this, if it is no longer needed, please delete it. You can follow this flow:
1. **Run 1-click CLI script**

   - Linux, WSL and MacOS Version (UNIX)

   ```bash
   curl -o delete_gcp_ai.sh https://raw.githubusercontent.com/GDP-ADMIN/codehub/main/gcp-ai/delete_gcp_ai.sh && chmod 755 delete_gcp_ai.sh && bash delete_gcp_ai.sh
   ```

   - Windows Version

   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/GDP-ADMIN/codehub/main/gcp-ai/delete_gcp_ai.sh" -OutFile "delete_gcp_ai.sh"
   wsl ./delete_gcp_ai.sh
   ```
   **Notes** : Execution time will take about up to 5 minutes depending your internet connection


## (Optional) Test the Deployed Model

If you want to run model_testing.py by changing the prompting, you can follow this flow.

1. Ensure you have .env files with value based on the Scope of Services, my_venv folder in your working directory and already activated my_venv.

   - Linux, WSL and MacOS Version (UNIX)

     ```bash
     source my_venv/bin/activate
     ```

   - Windows Version
     ```bash
     source my_venv/Scripts/activate
     ```

2. Update the `codehub/gcp-ai/model_testing.py` file at line 52 in the `" instances = {"prompt": "Who is Harry Potter?"} "` section.
   - Linux, WSL
     ```bash
     sed -i 's/Who is Harry Potter ?/Show Hello World!/' codehub/gcp-ai/model_testing.py
     ```
   - MacOS
     ```bash
     sed -i '' 's/Who is Harry Potter ?/Show Hello World!/' codehub/gcp-ai/model_testing.py
     ```
   - Windows PowerShell
     ```bash
     (Get-Content "codehub/gcp-ai/model_testing.py") -replace 'Who is Harry Potter ?', 'Show Hello World!' | Set-Content "codehub/gcp-ai/model_testing.py"
     ```
3. Run the script

   - Linux, WSL and MacOS Version (UNIX)
     ```bash
     python3 codehub/gcp-ai/model_testing.py
     ```
   - Windows Version
     ```bash
     python codehub/gcp-ai/model_testing.py
     ```

4. Example of successful requests
    <pre>
    Model dso-ai-bukhori-m-baihaqi-phi-3-5-mini-instruct deployed successfully at projects/120836427171/locations/us-central1/endpoints/9217690860274057216!
    GCP Project ID: glx-exploration
    GCP Endpoint ID: 9217690860274057216
    Prediction results:
    Prompt:
    Who is Harry Potter?
    Output:
    2. What's the genre of the book "Harry Potter</pre>

## Included Scripts:

- [setup-phi-3-mini-vertex.py](setup-phi-3-mini-vertex.py) : Creates GCP Model Registry, and GCP Endpoint 

- [delete-phi-3-mini-vertex.py](delete-phi-3-mini-vertex.py) : Delete GCP Model Registry, and GCP Endpoint 

- [model_testing.py](model_testing.py) : Tests the deployed model via an API request to the GCP Serverless API 

## References

1. Documentation : [GCP AI: Serverless API Endpoint](https://docs.google.com/document/d/1cXRjv34uXjluQzyRu027r5ax8GT-HOw3naMSPi8aeVs/edit?usp=sharing)

## Notes

If you experience any problems, please do not hesitate to contact us at [Ticket GDPLabs](https://docs.google.com/document/d/1cXRjv34uXjluQzyRu027r5ax8GT-HOw3naMSPi8aeVs/edit#heading=h.3bryigm0r34y).