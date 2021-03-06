#
# Only the values for Debian::trusty have been tested. Other distributions and OSs have are TODO.
#
class devhost::params {
  $devUser = 'dev'
  $devuserhome = '/home/dev'
  $devUserGroups = ['sudo']
  $devUserPassword = '$6$Ne11NDd00.gyr$wCVgF/PrwbunihnHyJXBkE5kklPh3EAeY3.qmqO3hz6pExONA6p.472BpQt6eh2zn6qIRBO26LlUgGsGE36s51'

  case $::osfamily {
    'Debian' : {
      $apacheRestart = 'service apache2 restart'
      $sshPkgName = 'openssh-server'
      # Packages to install on host development machines.
      $installPkgs = [
        'chromium-browser',
        'cmake',
        'colordiff',
        'curl',
        'emacs',
        'g++',
        'git',
        'htop',
        'iotop',
        'jedit',
        'libtool',
        'meld',
        'mysql-workbench',
        'password-gorilla',
        'ruby-dev',
        'screen',
        'sshfs',
        'subversion',
        'sysstat',
        'whois',
        'xchat',
        'gnome-terminal'
        ]
      $desktopPkgs = ['lubuntu-desktop']
      $dropboxPkg = 'nautilus-dropbox'
      $bootstrapPkgs = ['software-properties-common']

      case $::lsbdistcodename {
        'trusty'  : {
          $bundlerVersion = '1.3.5-2ubuntu1'
          $puppetPackageName = "puppetlabs-release-trusty.deb"
          $puppetVersion = '3.6.2-1puppetlabs1'
          $rubyShadowPkg = 'ruby-shadow'
        }
        'precise' : {
          # TODO Not supported yet.
          $bundlerVersion = undef
          $rubyShadowPkg = 'libshadow-ruby1.8'
          $puppetPackageName = "puppetlabs-release-precise.deb"
          $puppetVersion = '3.4.3-1puppetlabs1'
          $bundlerVersion = undef
          $uninstallPkgs = ['openjdk-6-jre-headless', 'openjdk-7-jre-headless', 'virtualbox']
        }
        default   : {
          fail("Unsupported Debian distribution: ${::lsbdistcodename}")
        }
      }

    }
    'RedHat' : {
      # TODO Not supported yet.
      $apacheRestart = 'service httpd restart'
      $devAdminGroup = 'root'
      $envDevInstallPkgs = []
      $librarianPuppetInstallCmd = undef
      $puppetPackageName = "http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm"
      $puppetVersion = '3.4.3-1'
      $rubyShadowPkg = 'ruby-shadow'
      $updatePkgManager = 'yum -y update'
    }
    default  : {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }
}

