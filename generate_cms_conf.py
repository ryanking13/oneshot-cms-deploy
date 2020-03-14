import json
import pathlib
import argparse

SERVICE_HOST = "localhost"

# 각 서비스가 사용하는 기본 포트 값
# 여러 개의 대회를 동시에 열기 위해서는 아래의 포트 값을 바꾸어 새로운 cms.conf 파일을 생성합니다

CONTEST_LISTEN_PORT = 8888  # docker-compose.yml의 포트 포워딩도 추가해주어야 합니다.
RESOURCE_SERVICE_PORT = 28000
SCOREING_SERVICE_PORT = 28500
CHECKER_PORT = 22000
EVALUATION_SERVICE_PORT = 25000
NUM_WORKERS = 16
WORKERS_PORT = [26000 + w for w in range(NUM_WORKERS)]
CONTEST_WEB_SERVER_PORT = 21000
PROXY_SERVICE_PORT = 28600
PRINTING_SERVICE_PORT = 25123
TEST_FILE_CACHER_PORT = 27501

# e.g)

# CONTEST_LISTEN_PORT = 9999
# RESOURCE_SERVICE_PORT = 38000
# SCOREING_SERVICE_PORT = 38500
# CHECKER_PORT = 32000
# EVALUATION_SERVICE_PORT = 35000
# NUM_WORKERS = 16
# WORKERS_PORT = [36000 + w for w in range(NUM_WORKERS)]
# CONTEST_WEB_SERVER_PORT = 31000
# PROXY_SERVICE_PORT = 38600
# PRINTING_SERVICE_PORT = 35123
# TEST_FILE_CACHER_PORT = 37501


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--output", "output filename", default="")

    return parser.parse_args()


def main():
    args = parse_args()

    conf_dir = pathlib.Path("cms-docker/conf")
    conf_path = conf_dir / "cms.conf"
    if not conf_path.exists():
        raise FileNotFoundError(
            f"{str(conf_path)} not exists, did you run `install.sh`?"
        )

    conf = json.loads(conf_path.read_text())

    core_services = conf["core_services"]
    other_services = conf["other_services"]

    core_services["ResourceService"][0] = [SERVICE_HOST, RESOURCE_SERVICE_PORT]
    core_services["ScoringService"][0] = [SERVICE_HOST, SCOREING_SERVICE_PORT]
    core_services["Checker"][0] = [SERVICE_HOST, CHECKER_PORT]
    core_services["EvaluationService"][0] = [SERVICE_HOST, EVALUATION_SERVICE_PORT]
    core_services["ContestWebServer"][0] = [SERVICE_HOST, CONTEST_WEB_SERVER_PORT]
    core_services["ProxyService"][0] = [SERVICE_HOST, PROXY_SERVICE_PORT]
    core_services["PrintingService"][0] = [SERVICE_HOST, PRINTING_SERVICE_PORT]

    core_services["Worker"] = []
    for worker_port in WORKERS_PORT:
        core_services["Worker"].append([SERVICE_HOST, worker_port])

    other_services["TestFileCacher"][0] = [SERVICE_HOST, RESOURCE_SERVICE_PORT]

    conf["contest_listen_port"] = [CONTEST_LISTEN_PORT]

    new_conf = json.dumps(conf, indent=2, ensure_ascii=False)

    output_file = args.output_file
    while not output_file:
        output_file = input("Config filename: ")

    new_conf_file = str(conf_dir / output_file)
    with open(new_conf_file, "w") as f:
        f.write(new_conf)

    print(f"Configuration save to: {new_conf_file}")
    print(f"Usage: CMS_CONFIG={output_file} run-contest \{contest_id\}")


if __name__ == "__main__":
    main()
