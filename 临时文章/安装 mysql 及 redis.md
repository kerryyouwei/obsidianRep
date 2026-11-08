  267  # 1. 安装 MySQL 服务
  268  sudo dnf install mysql-server -y
  269  # 2. 启动并设置开机自启
  270  sudo systemctl enable mysqld --now
  271  # 3. 查看运行状态
  272  sudo systemctl status mysqld
  273  sudo mysql -u root
  274  sudo mysql_secure_installation
  275  netstat -ltnp
  276  mysql -uroot -p
  277  mysql -uroot
  278  mysql -uroot -p
  279  sudo mysql_secure_installation
  280  netstat -ltnp
  281  mysql -uroot -p
  282  # 1. 直接安装
  283  sudo dnf install redis -y
  284  # 2. 设置开机自启并立即启动
  285  sudo systemctl enable redis --now
  286  # 3. 验证服务状态
  287  sudo systemctl status redis
  288  netstat -ltnp
  289  vi /etc/redis/redis.conf
  290  systemctl restart redis
  291  netstat -ltnp
  292  vi /etc/redis/redis.conf
  293  history


**1. 创建并授权远程用户**

登录 MySQL 后，执行以下 SQL（将 `远程用户`、`强密码` 和 `%` 替换为实际值）：
-- 创建用户，'%' 表示允许任意主机连接
CREATE USER 'youwei'@'%' IDENTIFIED BY 'Zhiming@14';

-- 授予该用户所有数据库的所有权限（可按需缩小范围）
GRANT ALL PRIVILEGES ON *.* TO 'youwei'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

**2. 调整 MySQL 绑定地址**

默认配置下，MySQL 可能只监听本地回环地址。需要检查配置文件 `/etc/my.cnf` 或 `/etc/my.cnf.d/` 下的文件。

找到 `[mysqld]` 部分，确保 `bind-address` 设置正确：

- 如果要监听**所有**网络接口，将其设为 `0.0.0.0`（或注释掉该行，但需确认默认行为）。
    
- 如果服务器有固定内网 IP，建议设为该 IP，例如 `bind-address = 192.168.1.50`。[](https://www.ibm.com/docs/en/tarm/8.20.5?topic=mysql-enabling-user-permissions-server#1)[](https://www.ibm.com/docs/pt-br/tarm/8.21.0?topic=mysql-enabling-user-permissions-server#1)
    

修改后重启 MySQL 服务：`sudo systemctl restart mysqld`。

**3. 配置防火墙**

Rocky Linux 默认使用 `firewalld`。需要放行 MySQL 的默认端口 3306：

bash

sudo firewall-cmd --permanent --add-service=mysql
sudo firewall-cmd --reload

如果只想允许特定网段访问，可以使用富规则替代上述命令：[](https://raw.githubusercontent.com/OneUptime/blog/refs/heads/master/posts/2026-03-31-mysql-install-rocky-linux-9/README.md#1)

bash

sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="mysql" accept'
sudo firewall-cmd --reload