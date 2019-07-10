# Remove-DS_Agent_IM_Rules
AUTHOR		: Yanni Kashoqa

TITLE		: Deep Security Agent Integrity Monitoring Rules Removal

DESCRIPTION	: This Powershell script will remove any Integrity Monitoring Rules assigned at the computer level based assigned Policy ID.

FEATURES
The ability to perform the following:-
- Access the Deep Security Manager using REST protocols to remove assigned IM Rules

REQUIRMENTS
- Supports Deep Security as a Service
- PowerShell 6.x
- An API key that is created on DSaaS console
- Create a DS-Config.json in the same folder with the following content:
{
    "MANAGER": "app.deepsecurity.trendmicro.com",
    "PORT": "443",
    "APIKEY" : ""
}