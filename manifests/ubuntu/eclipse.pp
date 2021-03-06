class devhost::ubuntu::eclipse (
  $package = "eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz",
  $weburl  = "http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/kepler/SR2/eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz&r=1"
) {

  ::eclipse { "eclipse":
    downloadurl        => $weburl,
    downloadfile       => $package,
    pluginrepositories => ['http://download.eclipse.org/releases/kepler/'],
  }

  # NOTE: The plugin class does not support upgrading over versions. To install a new version the old one will have to be
  # removed first.
  ::eclipse::plugin { 'kepler_plugins':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => [
      'http://download.eclipse.org/releases/kepler/',
      'http://www.fuin.org/p2-repository/',
      'http://download.eclipse.org/recommenders/updates/stable/',
      'http://download.eclipse.org/tools/pdt/updates/3.3.2/'],
    pluginius             => [
      'org.eclipse.dltk.core.feature.group/5.0.0.201306060709',
      'org.eclipse.dltk.core.index.feature.group/5.0.0.201306060709',
      'org.eclipse.dltk.ruby.feature.group/5.0.0.201306060709',
      'org.eclipse.wst.xml_ui.feature.feature.group/3.5.2.v201401062113-7H7IFizDxumVu0K6bjdPjXRkoz0FiUYMnSyT9PL',
      'org.eclipse.cdt.autotools.feature.group/8.3.0.201402142303',
      'org.eclipse.cdt.feature.group/8.3.0.201402142303',
      'org.eclipse.cdt.gdb.feature.group/8.3.0.201402142303',
      'org.eclipse.cdt.platform.feature.group/8.3.0.201402142303',
      'org.eclipse.cdt.gnu.dsf.feature.group/8.3.0.201402142303',
      'org.eclipse.cdt.gnu.build.feature.group/8.3.0.201402142303',
      'org.eclipse.cdt.gnu.debug.feature.group/8.3.0.201402142303',
      'org.eclipse.cdt.testsrunner.feature.feature.group/8.3.0.201402142303',
      'org.eclipse.php.feature.group/3.3.2.201410231314',
      'org.slf4j.api/1.7.2.v20121108-1250',
      'ch.qos.logback.classic/1.0.7.v20121108-1250'],
    checkforpluginfolders => [
      'org.eclipse.dltk',
      'org.eclipse.dltk.core',
      'org.eclipse.dltk.ruby',
      'org.eclipse.wst.xml',
      'org.eclipse.cdt',
      'org.eclipse.cdt.gdb',
      'org.eclipse.cdt',
      'org.eclipse.cdt',
      'org.eclipse.cdt',
      'org.eclipse.cdt',
      'org.eclipse.cdt.testsrunner',
      'org.eclipse.php',
      'org.slf4j.api',
      'ch.qos.logback.classic'],
    suppresserrors        => false
  }

  ::eclipse::plugin { 'xtext':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => ['http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/'],
    pluginius             => ['org.eclipse.xtext/2.4.3.v201309030823'],
    checkforpluginfolders => ['org.eclipse.xtext'],
    suppresserrors        => false
  }

  ::eclipse::plugin { 'geppetto':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => ['http://geppetto-updates.puppetlabs.com/4.x/'],
    pluginius             => [
      'com.puppetlabs.geppetto.feature.group/4.1.0.v20140215-1425',
      'com.puppetlabs.geppetto.puppetdb.feature.group/4.1.0.v20140128-0831'],
    checkforpluginfolders => ['com.puppetlabs.geppetto'],
    suppresserrors        => false
  }

  ::eclipse::plugin { 'mercurial':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => ['http://mercurialeclipse.eclipselabs.org.codespot.com/hg.wiki/update_site/stable/'],
    pluginius             => ['mercurialeclipse.feature.group/2.1.0.201304290948'],
    checkforpluginfolders => ['com.vectrace.MercurialEclipse'],
    suppresserrors        => false
  }

  ::eclipse::plugin { 'jsonsite':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => ['https://bitbucket.org/denmiroch/jsontools/src/default/JsonSite/'],
    pluginius             => ['org.sweetlemonade.eclipse.json.feature.feature.group/1.0.4'],
    checkforpluginfolders => ['org.sweetlemonade.eclipse.json'],
    suppresserrors        => true
  }

  ::eclipse::plugin { 'yamledit':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => ['http://dadacoalition.org/yedit/'],
    pluginius             => ['org.dadacoalition.yedit.feature.group/0.0.13'],
    checkforpluginfolders => ['org.dadacoalition.yedit'],
    suppresserrors        => false
  }

  ::eclipse::plugin { 'pydev':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => ['http://pydev.org/updates/'],
    pluginius             => ['org.python.pydev.feature.feature.group/3.7.1.201409021729'],
    checkforpluginfolders => ['org.python.pydev'],
    suppresserrors        => false
  }

  # Currently this will fail the first time puppet runs due to a bug
  # http://stackoverflow.com/questions/6470802/what-to-do-about-eclipses-no-repository-found-containing-error-messages.
  ::eclipse::plugin { 'shelled':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => [
      'http://download.eclipse.org/releases/kepler/',
      'http://download.eclipse.org/technology/dltk/updates/',
      'http://sourceforge.net/projects/shelled/files/shelled/update/'],
    pluginius             => ['net.sourceforge.shelled.feature.group/2.0.3'],
    checkforpluginfolders => ['net.sourceforge.shelled'],
    suppresserrors        => true
  }

  ::eclipse::plugin { 'nodeclipse':
    require               => ::Eclipse['eclipse'],
    pluginrepositories    => ['http://www.nodeclipse.org/updates/'],
    pluginius             => [
      'code.satyagraha.gfm.viewer.feature.feature.group/1.8.3',
      'com.eclipsesource.jshint.feature.feature.group/0.9.9.20131029-1050',
      'jsonedit-feature.feature.group/0.9.7',
      'markdown.editor.feature.feature.group/1.1.0.201402240523',
      'org.nodeclipse.enide.editors.jade.feature.feature.group/0.17.0.201409260936',
      'org.chromium.sdk.feature.group/0.3.9.201409260936',
      'org.chromium.debug.feature.group/0.3.9.201409260936',
      'org.nodeclipse.feature.group/0.17.0.201409260936',
      'org.nodeclipse.mongodb.feature.feature.group/0.17.0.201409260936',
      'org.nodeclipse.pluginslist.feature.feature.group/0.1.0.20130811-1427',
      'code.google.restclient.tool.feature.feature.group/1.0.3'],
    checkforpluginfolders => [
      'code.satyagraha.gfm',
      'com.eclipsesource.jshint',
      'jsonedit-feature',
      'markdown.editor',
      'org.nodeclipse',
      'code.google.restclient'],
    suppresserrors        => true
  }

}
