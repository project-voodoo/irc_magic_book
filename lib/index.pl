#!/usr/bin/perl
#  # project-voodoo logparser v0.21
#  author : putkte/Frd^freenode @2010
#  why : for #project-voodoo channel log parser
#  code is not pretty but does job nicely =)
#  
######################################################################
use Date::Calc qw(:all);
my $outputfile = "output/index.html";
my $template = "templates/index.html";

/*
  read files from log folder and makes hashtable.
*/
sub get_files_list {
	my %files;
	my $file_date;
	my @files = <./output/project*log*.html>;
		foreach $file (@files) {
			$file =~ m/\/.*\/(.*\.html)/;
			$ffile = $1;
			my $filedate = &get_file_date($ffile);
			my $filesize = -s $file;
		   	$files{$ffile} =  $filedate;
		   	$files{$ffile}{'size'} =  $filesize;
	 } 
  return %files;
}
/*
 	get date from file name
*/
sub get_file_date {
	my ($filename) = @_;
	if ( $filename =~ m/([\d]{4}-[\d]{1,2}-[\d]{1,2})/ ) {
		$file_date = $1;
	}
	return $file_date;
}
/*
	writes skell to output file.
*/
sub write_skells {
	print("SKELLS to :$outputfile ");
	open (FILE ,$template);
	my @SKELL = <FILE>;
  	close (FILE);
 	open (OUTPUT,">$outputfile");
  	my $i = 0;
	while ( $SKELL[$i] ){
		print OUTPUT "$SKELL[$i]";
		 $i++;
	}  
	print("[DONE]\n");
	close(OUTPUT);
}
/*
	writes skell ending to output file.
*/
sub write_skells_end {
	my $file_end = "<div class=\"footer\" style=\"position: absolute; top: 99%; left: 240px;\"><div>©Frd^\@freenode (IRC log parser author) 2010</div></div></body>\n</html>\n";
	open (OUTPUT,">>$outputfile");
	print OUTPUT "$file_end";
	 close(OUTPUT);
}
/*
	makes calender skells.
*/
sub skell_calendar {
	my ($year,$month,$day,$c_index) = @_;
    my $top=40;
    my $left=10;
    my %c_index_pos_left = (1,10,2,240,3,480,4,10,5,240,6,480,7,10,8,240,9,480,10,10,11,240,12,480);
    my %c_index_pos_top = (1,40,2,40,3,40,4,320,5,320,6,320,7,640,8,640,9,640,10,960,11,960,12,960);
	$left = $c_index_pos_left{$c_index};
	$top = $c_index_pos_top{$c_index};
	#print ("LEFT: $left\n");
	if ( not defined $year || not defined $month || not defined $day) { die }
	my $calender;
	$dow = Day_of_Week($year,$month,"01");
	$DW_string = Day_of_Week_to_Text($dow);
	$M_str = Month_to_Text($month);
	$d=1;
	if ( $DW_string eq "Monday") { $d=1; }
	if ( $DW_string eq "Tuesday") { $d=2; }
	if ( $DW_string eq "Wednesday") { $d=3; }
	if ( $DW_string eq "Thursday") { $d=4; }
	if ( $DW_string eq "Friday") { $d=5; }
	if ( $DW_string eq "Saturday") { $d=6; }
	if ( $DW_string eq "Sunday") { $d=7; }
	$calender = $calender = "<div class=\"cal$c_index\" style=\"position: absolute; top:".$top."px; left: ".$left."px;\">\n<h3>$M_str $year</h3>\n";
	my $days = Days_in_Month($year,$month);
	$calender = $calender ."<table style=\"border:0\">\n";
	$calender = $calender ."<tr><td class=\"calday\">M</td><td class=\"calday\">T</td><td class=\"calday\">W</td><td class=\"calday\">T</td><td class=\"calday\">F</td><td class=\"calday\">S</td><td class=\"calday\">S</td></tr>";
	## makes empty days before so first day is in correct position.
	for ($i=1;$i<$d;$i++) {
		$calender = $calender ."<td class=\"calender\"></td>";
	}
	for ($i=1;$i<=$days;$i++) {
	    # fixing day print 1-9 to 01-09
        if ( $i <10 ) { 
			$i_pr = "0".$i; 
		} 
		else { 
			$i_pr = $i; 
		}
		# print daus in calemdar.	
		if ( $d < 7 ){
			$calender = $calender ."<td class=\"calender\"><div style=\"position: absolute; z-index: 3;\"><a href=#LINK$i_pr#>$i_pr</a></div><div style=\"overflow:hidden;height:#PERCENT$i_pr#\"><img src=\"meter.png\" /></div></td>";
			$d++;
		}	
		else {
			$calender = $calender ."<td class=\"calender\"><div style=\"position: absolute; z-index: 3;\"><a href=#LINK$i_pr#>$i_pr</a></div><div style=\"overflow:hidden;height:#PERCENT$i_pr#\"><img src=\"meter.png\" /></div></td></tr>\n";
			$calender = $calender ."<tr>";
		 	$d=1;	
		}	
	}
	$calender = $calender ."</tr>\n</table>\n";
	$calender = $calender ."</div>\n";
}
/*
	adds log links to calenders.
*/
sub make_calendars {
	my (%files) = @_;
	my $month_l = 0;
	my $c_index = 1;
	my %calendars;
	foreach my $f (sort (keys %files)) {
		print("FILE : $f : date : $files{$f} fsize: $files{$f}{size}\ \n");
		my ($year,$month,$day) = split(/-/,$files{$f});
		my $fsize = $files{$f}{'size'}/1024; 
  		if ( $fsize =~ m/(0\.[0-9]{1,2})/ ) {
		     $fsize_pr = $1;
		}
		if ( $fsize =~ m/([0-9]{1,3}\.[0-9]{1})/ ) {
		     $fsize_pr = $1;
		}
		if ( $fsize_pr > 100 ) { $fsize_pr = 100;} 
		print("MAKE CALENDERS: $f : $files{$f} ".$fsize_pr ."%\n");
		
		if ( $month eq $month_l ) {
			$cal =~ s/#LINK$day#/\"$f\"/;
			$cal =~ s/#PERCENT$day#/$fsize_pr%/;
			$calendars{"$year.$month"} = $cal;
		} else {
			$calendars{"$year.$month"} = $cal;
			$month_l = $month;
			$cal = &skell_calendar($year,$month,$day,$c_index);
			$c_index++;
			$cal =~ s/#LINK$day#/\"$href\"/;
			$cal =~ s/#PERCENT$day#/$fsize_pr%/;
		}
	}	
	print("MAKE CALENDERS: [DONE]\n");
	return %calendars;
}
/*
	removes rest skell link and procent positions.
	writes all calendars to outputfile.
*/
sub write_calenders {
	print("WRITING CALENDERS to $outputfile ");
	my (%calenders) = @_;
	open (OUTPUT,">>$outputfile");
	foreach my $cals (sort (keys %calenders)) {
			$cal = $calenders{$cals};	
			for ($i=1;$i<=31;$i++) {
        		if ( $i <10 ) { 
						$i_pr = "0".$i; 
				} 
				else { 
					$i_pr = $i; 
				}	
			$cal =~ s/#LINK$i_pr#/""/g;
			$cal =~ s/#PERCENT$i_pr#/0%/g;
			}
			print OUTPUT $cal;
	}
  	close (OUTPUT);
	print("[DONE]\n");
}
/*
	the main function
*/
sub main {
	&write_skells();
	my %files = &get_files_list();
	my %calendars = &make_calendars(%files);
	&write_calenders(%calendars);
	&write_skells_end();
}
&main();
