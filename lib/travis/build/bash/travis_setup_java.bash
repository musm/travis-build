travis_setup_java() {
  local jdkpath jdk vendor version
  jdk="$1"
  vendor="$2"
  version="$3"
  jdkpath="$(travis_find_jdk_path "$jdk" "$vendor" "$version")"
  if [[ -z "$jdkpath" ]]; then
    echo No path was found matching the jdk
    echo 'travis_install_jdk "$vendor" "$version"'
    travis_install_jdk "$vendor" "$version"
  elif compgen -G "${jdkpath%/*}/$(travis_jinfo_file "$vendor" "$version")" &>/dev/null &&
    declare -f jdk_switcher &>/dev/null; then
    echo 'An apt-managed jdk was found matching the target jdk'
    travis_cmd "jdk_switcher use \"$jdk\"" --echo --assert
    if [[ -f ~/.bash_profile.d/travis_jdk.bash ]]; then
      sed -i '/export \(PATH\|JAVA_HOME\)=/d' ~/.bash_profile.d/travis_jdk.bash
    fi
  else
    echo Local jdk was found matching target jdk
    find $jdkpath -type f
    echo $jdkpath
    export JAVA_HOME="$jdkpath"
    export PATH="$JAVA_HOME/bin:$PATH"
    if [[ -f ~/.bash_profile.d/travis_jdk.bash ]]; then
      sed -i "/export JAVA_HOME=/s/=.\\+/=\"$JAVA_HOME\"/" ~/.bash_profile.d/travis_jdk.bash
    fi
  fi
}