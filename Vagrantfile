Vagrant.configure("2") do |config|

    config.vbguest.auto_update = false

    # 対象box設定
    config.vm.box = "centos67"
    config.vm.box_url = "https://github.com/CommanderK5/packer-centos-template/releases/download/0.6.7/vagrant-centos-6.7.box"

    # 外部から接続するIP
    config.vm.network "private_network", ip: "192.168.33.100"

    # メモリーサイズ
    config.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = 1024
    end

    # 共有フォルダの指定
    config.vm.synced_folder ".",
                            "/var/www/html",
                            :mount_options => ["dmode=775,fmode=775"]

    # [初回のみ]必要なパッケージのインストール等初期設定
    config.vm.provision :shell, :path => "provision/provision.sh"

    # シンボリックリンクがうまくいかずhttpdが自動起動しない場合の対策
    config.vm.provision :shell, run: "always", :inline => <<-EOT
        service httpd restart
    EOT

end
