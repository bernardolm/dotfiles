from datetime import datetime, timedelta
from os import environ

import requests
import requests_cache
from github import Github

GITHUB_ORG = environ.get("GITHUB_ORG", "")
GITHUB_TOKEN = environ.get("GITHUB_TOKEN", "")
GITHUB_USER = environ.get("GITHUB_USER", "")
PER_PAGE = 100


expire_after = expire_after = timedelta(hours=12)
requests_cache.install_cache('demo_cache', expire_after=expire_after)


gh = Github(
    login_or_token=GITHUB_TOKEN,
    per_page=PER_PAGE
)

org = gh.get_organization(GITHUB_ORG)

total_additions, total_deletions, total_commits, repo_position = 0, 0, 0, 0

now = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")


with open(
        file=f"my-git-stats_{GITHUB_ORG}_{GITHUB_USER}_{now}.log", mode="a",
        encoding="utf-8") as file:

    to_log = f"{org.get_repos().totalCount} repos found " \
        f"in {GITHUB_ORG} at {now}\n\n"
    print(to_log)
    file.write(to_log)

    for repo in org.get_repos():
        repo_position += 1

        url = f"https://api.github.com/repos/{GITHUB_ORG}/{repo.name}" \
            f"/stats/contributors?per_page={PER_PAGE}"

        req = requests.get(
            url=url,
            timeout=60,
            headers={
                "Accept": "application/vnd.github+json",
                "Authorization": f"Bearer {GITHUB_TOKEN}",
                "X-GitHub-Api-Version": "2022-11-28"
            }
        )

        if req.status_code != 200:
            continue

        contributors = req.json()

        for cont in contributors:
            if cont['author']['login'] == GITHUB_USER:
                weeks = cont['weeks']

                repo_additions, repo_deletions, repo_commits = 0, 0, 0

                for week in weeks:
                    repo_additions = repo_additions + int(week['a'])
                    repo_deletions = repo_deletions + int(week['d'])
                    repo_commits = repo_commits + int(week['c'])

                to_log = f"repo={repo.full_name}\n" \
                    f"repo_additions={repo_additions}, " \
                    f"total_additions={total_additions}, " \
                    f"then {total_additions}+{repo_additions}=" \
                    f"{total_additions+repo_additions}\n" \
                    f"repo_deletions={repo_deletions}, " \
                    f"total_deletions={total_deletions}, " \
                    f"then {total_deletions}+{repo_deletions}=" \
                    f"{total_deletions+repo_deletions}\n" \
                    f"repo_commits={repo_commits}, " \
                    f"total_commits={total_commits}, " \
                    f"then {total_commits}+{repo_commits}=" \
                    f"{total_commits+repo_commits}\n" \
                    f"repo_position={repo_position}\n\n"

                print(to_log)
                file.write(to_log)

                total_additions = total_additions + repo_additions
                total_deletions = total_deletions + repo_deletions
                total_commits = total_commits + repo_commits

                break

    to_log = f"totals:\n" \
        f"total_additions={total_additions}, \n" \
        f"total_deletions={total_deletions}, \n" \
        f"total_commits={total_commits}, \n" \
        f"final repo_position={repo_position}, \n"

    print(to_log)
    file.write(to_log)

file.close()
