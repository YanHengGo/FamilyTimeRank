# scripts/codex_review.py
import os
import sys
import json
import urllib.request

API_KEY = os.environ.get("OPENAI_API_KEY")
MODEL = "gpt-4o-mini"  # 好きなモデル名に変更可

if not API_KEY:
    print("ERROR: OPENAI_API_KEY is not set", file=sys.stderr)
    sys.exit(1)

if len(sys.argv) < 2:
    print("Usage: python codex_review.py <diff_file_path>", file=sys.stderr)
    sys.exit(1)

diff_path = sys.argv[1]

with open(diff_path, "r", encoding="utf-8", errors="ignore") as f:
    diff_text = f.read()

system_prompt = """あなたはiOS/Swift/SwiftUIに詳しいシニアエンジニアとして、
GitHubのPull Requestをレビューします。

- 出力は日本語
- 冒頭に「総評」を短く
- その後、以下の3つに分類して箇条書きで指摘を書く
  - 重大
  - 中
  - 軽微
- 各指摘には「理由」と「簡単な修正例」があるとベスト
- トーンはフレンドリーだが、内容は具体的・実務的
"""

user_prompt = f"""以下は GitHub Pull Request の diff です。

これをレビューしてください。

```diff
{diff_text}
```"""

payload = {
    "model": MODEL,
    "messages": [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt},
    ],
    "temperature": 0.2,
    "max_tokens": 1500,
}

req = urllib.request.Request(
    "https://api.openai.com/v1/chat/completions",
    data=json.dumps(payload).encode("utf-8"),
    headers={
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}",
    },
)

try:
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read().decode("utf-8"))
        content = data["choices"][0]["message"]["content"]
        print(content)
except Exception as e:
    print(f"ERROR calling OpenAI API: {e}", file=sys.stderr)
    sys.exit(1)

