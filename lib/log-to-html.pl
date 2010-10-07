#!/usr/bin/perl
#  # project-voodoo logparser v0.2
#  author : putkte/Frd^freenode @2010
#  why : for #project-voodoo channel log parser
#  code is not pretty but does job nicely =)
#  
######################################################################

my $file_date;

my %nicknames;
my %nicknamesid;
my %nicknameanon;
my $nicksanon = 1;
my $nicks = 1;

##
## 	Get filename from file name small regex
##
sub get_file_date {
   my ($filename) = @_;
   if ( $filename =~ m/([\d]{4}-[\d]{1,2}-[\d]{1,2})/ ) {
	$file_date = $1;
 	print("FILEDATE : $file_date\n");
	}
}
##
## reads irc-log.html and writes it to index.html
##

sub write_skells {
  my ($file) = @_;
  print("SKELLS to :$file\n");
  open (FILE ,"templates/irc-log.html");
  my @SKELL = <FILE>;
  close (FILE);

open (OUTPUT,">$file.html");
my $i = 0;

while ( $SKELL[$i] ){
   if ($SKELL[$i] =~ m/(.*)(#DATE#)(.*)/ ) {
	print OUTPUT "$1"."$file_date"."$3";
	} else {
	print OUTPUT "$SKELL[$i]";
	}
 $i++;
}  
  print("SKELLS : DONE!\n");
close(OUTPUT);
}
##
## writes index.html file skell ending.
##
sub write_skells_end {
  my ($file) = @_;
my $file_end = "<table>\n</body>\n</html>\n";
open (OUTPUT,">>$file.html");
   print OUTPUT "$file_end";
  close(OUTPUT);
}
##
## 	converts logs to html file.
##
sub convert_logs {
##
##	opens files and reads it to array info
##	then runs through array and finds lines what matches on regex line.
##	takes time nick and message from those and adds to td line.
##
open (FILE ,$ARGV[0]);
my @info = <FILE>;
close (FILE);
my $file = $ARGV[0];
open (OUTPUT,">>$file.html");
my $i = 0;
while ( $info[$i] ){
      if ( $info[$i] =~ m/(^\[\d{1,2}:\d{1,2}\]).<([a-zA-Z_\.\-\+\|\^]{1,15})>(.*)/ ) {
	  my $time = $1;
	  my $nick = $2;
	  my $to_message;
	  my $message = $3;
	  #print("line: $info[$i]\n");
	  #print("time: $time # nick $nick # $message\n");
	  # small fix on nick lines. so if finds char > on nick then regexp did not work correct that small thin fixes it.
      if ( rindex($nick,'>') ne "-1" ) {
			$nick_l = length($nick);
			#print ("nick :$nick :$nick_l i:".rindex($nick,'>',13)."\n");
			$to_message = substr($nick,rindex($nick,'>',13)+1,$nick_l);
			$nick = substr($nick,0,rindex($nick,'>',13));
			#print ("nick :$nick :".rindex($nick,'>',13)."\n");
			#print ("tomes :$to_message\n");
		}
		#	hidin anon nicks.
	  	if ( $nick =~ m/\|anon$/ ) {                
              if ( not defined $nicknameanon{$nick} ) {
				  $nicknameanon{$nick} = reverse(substr($nick,0, index($nick, '|anon')))."|anon";
                  $nicksanon++;
                  $nick = $nicknameanon{$nick};
              } else {
                  $nick = $nicknameanon{$nick};
              }
          } elsif ( $nick =~ m/_anon$/ ) {
              if ( not defined $nicknameanon{$nick} ) {
                  $nicknameanon{$nick} = reverse(substr($nick,0,index($nick, '_anon')))."_anon";
                  $nicksanon++;
                  $nick = $nicknameanon{$nick};
              } else {
                  $nick = $nicknameanon{$nick};
              }
          } elsif ( $nick =~ m/\|nolog$/ ) {
              if ( not defined $nicknameanon{$nick} ) {
                  $nicknameanon{$nick} = reverse(substr($nick,0,index($nick, '|nolog')))."|nolog";
                  $nicksanon++;
                  $nick = $nicknameanon{$nick};
              } else {
                  $nick = $nicknameanon{$nick};
              }
          } elsif ( $nick =~ m/_nolog$/ ) {
              if ( not defined $nicknameanon{$nick} ) {
                  $nicknameanon{$nick} = reverse(substr($nick,0,index($nick, '_nolog')))."_nolog";
                  $nicksanon++;
                  $nick = $nicknameanon{$nick};
              } else {
                  $nick = $nicknameanon{$nick};
              }
		}
		$message = $to_message.$message;
        $to_message = "";
		foreach my $key (keys %nicknameanon) {
				$message =~ s/$key/$nicknameanon{$key}/;
		}
	  # adds nick to hastable and givs then number waht indicates cologs on webpage
		if ( not defined  $nicknames{$nick} ) { 
			$nicknames{$nick} = $nicks ;
			$nicks++; 
			if ( $nicks > 15) { $nicks = 1; }
			}
			print OUTPUT "<tr id='$nick' ><td class='time' id='$nick'>$time</td><td id='$nick' class='nick$nicknames{$nick}'><a onclick=\"javascript:clicknick(\'$nick\');\">$nick</a></td><td id='$nick' class='message'>$message</td></tr>\n";
	}
  $i++;
}
  	print("CONVERTED $i lines\n");
	close(OUTPUT);
}
#clas sub fucktions to make logs =)
&get_file_date($ARGV[0]);
&write_skells($ARGV[0]);
&convert_logs($ARGV[0]);
&write_skells_end($ARGV[0]);
