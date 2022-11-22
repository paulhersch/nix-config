{ pkgs, ... }:

''
[ -z $session ] && session=awesome
case $session in
	awesome)
		xrdb -load .Xresources
		awesome
		;;
esac
''
		#exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
