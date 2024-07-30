# Workspace da FRTL 2024

Vamos fazer o setup dos pacotes necessários para enviar comandos de offboard control para o drone no Gazebo utilizando PX4-Autopilot, ROS 2 e o protocolo uXRCE-DDS.

### Explicando o que é cada pacote

- **PX4-Autopilot**: é o mesmo firmware de PX4 1.14 que roda na PixHawk. Por default, esse pacote também baixa o Gazebo.

- **ROS 2**: Sistema operacional que facilita a comunicação entre diferentes partes do drone, tanto entre componentes físicos como de software.

- **MicroXRCE-Agent**: Agente que traduz tópicos de ROS 2 para tópicos uORB (PX4).

- **px4_ros_com**: Pacotes de comunicação ROS 2 para PX4.

- **px4_msgs**: Mensagens ROS 2 utilizadas pelo PX4.

- **frtl_2024**: contém a classe Drone (implementa funções que enviam px4_msgs) e também as máquinas de estados para resolver as fases.

- **simulation**: Repositório com modelos de mundo e configurações do drone para a simulação.

### Explicando a estrutura do workspace

```
home/
├── PX4-Autopilot
├── MicroXRCE-Agent
├── frtl_2024_ws/
    ├── src/
        ├── px4_msgs
        ├── px4_ros_com
        ├── frtl_2024
        ├── simulation
    ├── tasks/
        ├── build_ws.sh
        ├── simulate.sh
```

## Pré-requisitos

- **Sistema Operacional**: Ubuntu 22.04
- **Dependências**:
  - Github CLI (Configure aqui)
  - CMake
  - Python 3
  - Pip

### Configurando o GitHub

- Baixando gh:
    ```bash
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
    ```
- gh auth login: rode `gh auth login`, depois siga os passos selecionando HTTPS. 

- Obs: certifique-se de que você tem acesso ao repositório da eVTOL no Github.


## Setup do Ambiente

### 1. Instalar Dependências

```sh
sudo apt update
sudo apt install -y git cmake python3-colcon-common-extensions
pip install --user -U empy==3.3.4 pyros-genmsg setuptools
```

### 2. Instalar QGroundControl

1. Rode no terminal:
```bash
sudo usermod -a -G dialout $USER
sudo apt-get remove modemmanager -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
sudo apt install libfuse2 -y
sudo apt install libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor0 -y
```

2. Faça logout e login para valer as mudanças.

3.  Download o [QGroundControl.AppImage](https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage)

4. Rode no terminal:
    ```bash
    chmod +x ./QGroundControl.AppImage
    ./QGroundControl.AppImage
    ```

### 3. Instalar ROS 2 Humble

```sh
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update && sudo apt upgrade -y
sudo apt install ros-humble-desktop
sudo apt install ros-dev-tools
source /opt/ros/humble/setup.bash && echo "source /opt/ros/humble/setup.bash" >> .bashrc
```

### 4. Baixar MicroXRCE-Agent

```sh
cd ~
git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
cd Micro-XRCE-DDS-Agent
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/
```

### 5. Baixar PX4-Autopilot (com Gazebo)

```sh
cd ~
git clone https://github.com/PX4/PX4-Autopilot.git --recursive
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh
cd PX4-Autopilot/
make px4_sitl
```

### 6. Setup do frtl_2024_ws

O script `setup.sh` fará o download dos repositórios necessários, além de buildar o workspace todo.

 - Execute a task Setup.

  - Obs: para executar uma task no VSCode, `crtl+shift+P` e selecione `Tasks: run Task`.

## Teste para ver se está tudo ok

- **Primeiro terminal**: rode a simulação PX4 com Gazebo
  
  ```bash
  export GZ_SIM_RESOURCE_PATH=/home/vinicius/PX4-Autopilot/Tools/simulation/gz
  cd ~/PX4-Autopilot && make px4_sitl gz_x500
  ```

- **Segundo terminal**: inicie o agente uXRCE-DDS
  
  ```bash
  MicroXRCEAgent udp4 -p 8888
  ```

- **Terceiro terminal**: rode o pacote de ROS 2 que você quiser. Um exemplo:
  
  ```bash
  source install/local_setup.bash
  ros2 run px4_ros_com offboard_control
  ```

## Rodando a simulação

- Execute a task Agent
- Execute a task Simulate
- Abra um terminal: `source install/local_setup.bash`
- Rode no terminal o pacote de ROS de voo autonômo: `ros2 run <nome_do_pacote> <nome_do_executavel>`
  
  - Ex: `ros2 run frtl_2024_demo takeoff_and_land`

## Referências

- [PX4 ROS 2 User Guide](https://docs.px4.io/main/en/ros2/user_guide.html#installation-setup)
- [ROS 2 Offboard Control Example](https://docs.px4.io/main/en/ros2/offboard_control.html)

