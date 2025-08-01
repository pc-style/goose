# Provider Setup Guide for Goose Autonomous Project Team

This guide walks you through setting up API keys for leading language model providers (Anthropic, OpenAI, OpenRouter), configuring your Goose environment, troubleshooting, and tips for cost-saving.

---

## 1. Anthropic

**Sign Up & Get API Key:**
1. Visit https://console.anthropic.com/ and sign up or log in.
2. Navigate to API Keys section in the dashboard.
3. Generate a new API key. **Copy and store it securely.**

**Config Example:**
```
ANTHROPIC_API_KEY=sk-ant-...
```

---

## 2. OpenAI

**Sign Up & Get API Key:**
1. Visit https://platform.openai.com/signup and create an account.
2. Go to https://platform.openai.com/api-keys.
3. Click "Create new secret key" and copy the key.

**Config Example:**
```
OPENAI_API_KEY=sk-...
```

---

## 3. OpenRouter

**Sign Up & Get API Key:**
1. Visit https://openrouter.ai/ and sign up.
2. Go to https://openrouter.ai/account/keys.
3. Generate and copy your API key.

**Config Example:**
```
OPENROUTER_API_KEY=... 
```

---

## 4. Adding Keys to Goose

1. Copy `.env.template` to `.env` in your project root.
2. Fill in your API keys as shown above.
3. Goose and extensions will automatically load these from `.env` or environment variables.

---

## 5. Troubleshooting

- **Missing Key Error:** Ensure `.env` is present and variables are set, or export them in your shell.
  - Example: `export OPENAI_API_KEY=sk-...`
- **Provider Quota/Account Issues:** Log in to the provider portal and check usage/quota.
- **Connection Errors:** Check your network/firewall. Some providers block VPNs or non-standard regions.
- **Model Not Found:** Update Goose and check provider/model availability.

---

## 6. Cost-Saving Tips

- Use OpenRouter for access to multiple models at competitive rates.
- Set usage/budget limits in provider dashboards.
- Use smaller context/models for research, planning, and doc writer roles; reserve larger models for developer/reviewer/QA.
- Monitor usage with provider dashboards and Goose logs.

---

## 7. Provider Links

- [Anthropic Console](https://console.anthropic.com/)
- [OpenAI Platform](https://platform.openai.com/)
- [OpenRouter](https://openrouter.ai/)

---

For further help, see Goose documentation or community forums.