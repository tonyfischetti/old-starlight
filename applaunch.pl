#!/usr/bin/perl


#	 Copyright (c) 2008, Anthony Fischetti
#	 All rights reserved.
#	
#	 This is free software with a BSD-derived license. This code may be redistributed
#	 and used in source and binary forms, *WITH OR WITHOUT* modification, provided that
#	 the following conditions are met:
#	     * Redistributions of source code must retain the above copyright
#	       notice, this list of conditions and the following disclaimer.
#	     * Redistributions in binary form must reproduce the above copyright
#	       notice, this list of conditions and the following disclaimer in the
#	       documentation and/or other materials provided with the distribution.
#	     * The author(s) may NOT be used to endorse or promote products
#	       derived from this software without specific prior written permission.
#	
#	 THIS SOFTWARE IS PROVIDED BY ANTHONY FISCHETTI ``AS IS'' AND ANY
#	 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#	 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#	 DISCLAIMED. IN NO EVENT SHALL ANTHONY FISCHETTI BE LIABLE FOR ANY
#	 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#	 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#	 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#	 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#	 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#	 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



use strict;

use Tk;

my $colour = "black";    #default colour value
my @matches;

my $mw = new MainWindow( -background=>$colour );
$mw->geometry( "1050x840" );
my $usrentry;
my @commands;
my @names;

	my ($sec,$min,$hour,$mday,$mon,$yyear,$wday,$yday,$isdst) =  localtime(time);
	my $yyyear = $yyear + 1900;
	my @abbr = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );

$mw->title('Starlight Application Launcher');
$mw->bind("<Key-Return>", \&enterpressed );
$mw->bind("<Key>", \&update );
my $sw = $mw->screenwidth;
my $sh = $mw->screenheight;
my $awplace = $sw/2-1050/2;		##########
my $ahplace = $sh/2-840/2;		##########
$mw->MoveToplevelWindow ($awplace,$ahplace);


$mw->focus();

my $label = $mw->Label( -background=>$colour, -foreground=>'white', -text=>"STARLIGHT" );
my $time; my $time2;
if( $hour > 12 ){ $time = $hour-12; }
else{ $time = $hour; }
if( $min < 10 ){ $time2 = "0"."$min"; }
else{ $time2 = $min;; }
my $lastlabel = $mw->Label( -background=>$colour, -foreground=>'red', -text=>"$abbr[$mon] $mday, $yyyear    $time:$time2" );
my $penlabel = $mw->Label( -background=>$colour, -foreground=>'white', -text=>"" );



my $label5 = $mw->Label( -background=>$colour, -foreground=>'white', -text=>"       notes:                                                                                                                            reminders:" );
my $label10 = $mw->Label( -background=>"black", -foreground=>'black', -text=>" " );

my $entry = $mw->Entry( -textvariable=>\$usrentry, -background=>"yellow", -foreground=>"black" );


open( my $fh, "/home/tony/applaunch/apps.txt" ) or die "$!";
while(<$fh>){
	my $line = $_;
	if( $line =~ m/^#/ ){ next; }
	if( $line =~ m/^\n$/ ){ next; }
	my $com = (split "\t", $line)[1];
	my $nam = (split "\t", $line)[0];
	push @commands, $com;
	push @names, $nam;
}
close $fh;

my $label2 = $mw->Label( -background=>$colour, -foreground=>'white', -text=>"" );
my $label3 = $mw->Label( -background=>$colour, -foreground=>'white', -text=>"" );
my $label9 = $mw->Label( -background=>$colour, -foreground=>'white', -text=>"" );

my @copy = @names;

my $lb2 = $mw->Text( -foreground=>"yellow", -background=>"black", -wrap=>"word", 
		-borderwidth=>0, -font=>[-weight=>'bold', -size=>'6', -family=>'Arial'], -width=>85, -height=>5 );

my $frame = $mw->Frame();
my $frame2 = $frame->Frame();

my $lb3 = $frame2->Scrolled( 'Text',-scrollbars=>"oe", -foreground=>"white", -background=>"black", -wrap=>"word", 
					-borderwidth=>0, -font=>[-weight=>'bold', -size=>'6', -family=>'Arial'], -width=>60, -height=>32 );
#my $srl_y = $frame2-> Scrollbar(-orient=>'v',-command=>[yview => $lb3]);

					
my $lb4 = $mw->Scrolled( 'Text',-scrollbars=>"oe", -foreground=>"white", -background=>"black", -wrap=>"word", 
					-borderwidth=>0, -font=>[-weight=>'bold', -size=>'6', -family=>'Arial'], -width=>60, -height=>32 );



my $lb6 = $mw->Text( -foreground=>"purple", -background=>"black", -wrap=>"word", 
		-borderwidth=>0, -font=>[-weight=>'bold', -size=>'6', -family=>'Arial'], -width=>110, -height=>2 );

my $results = `ps aux`;
my @res = split '\n', $results;
my @list = ();
$lb6->insert( 'end', "OPEN APPLICATIONS:   " );
foreach( @res ){
        my @line = split /\s+/, $_;
        my $lin = $line[10];
        if( $lin !~ /\[/ and $lin !~ /^\/usr/ and $lin !~ /^\/+s*bin/ and
           $lin !~ /daemon|bash|sh|^python$|trackerd|nm-applet|run-parts|sleep|COMMAND|nautilus|gnome-pty-helper|hald|ps|gnome-panel|x-session-manager|applet|gnome-power-manager|gnome-screensaver|update-notifier/ ){
                if( $lin =~ /songbird/ ){ $lin = "songbird";; }
                else{   push @list, $lin; }
                print "$lin\n";			$lb6->insert( 'end', " $lin   " );
        }
}


my $bigstring = " ";

for( my $scrubs = 0; $scrubs <= $#copy; $scrubs++ ){
	$bigstring.=$copy[$scrubs];
	$bigstring.="  ";
}
$lb2->insert( "end", $bigstring );
$lb2->configure( -state=>"disabled" );

chdir( );
open my $H, "<NOTES";
while( <$H> ){
	$lb3->insert( 'end', " * $_\n" );
}



lezg:
$lb4->delete( "1.0", "end" );
open my $H, "<REMS";
my @allentries = <$H>;
@allentries = sort{ $a <=> $b } @allentries;
my $counter = 0;
foreach( @allentries ){
	$counter++;
	my $enterthewutang = $_;
	print "\n!!!!!!!!!!$enterthewutang!!!!!!!!\n";
	my $m = 0;
	my $d = 0;
	my $y = 0;
	$enterthewutang =~ /^(\w+)\/(\w+)\/(\w{4})/;
	print "\n<><>$1<><>$2<><>$3<><>\n";
	my $addto = processREM2( $1, $2, $3, " " );;
	if( $counter != 1 and $addto >= 0){ $lb4->insert( 'end', "$addto DAYS LEFT!\n\t$_\n" ); }
}




$lb2->configure( -font=>[-weight=>'bold', -size=>'6', -family=>'Arial'] );

$lb2->tagConfigure('STRG',  -foreground => "green", -font=>[-weight=>'bold', -size=>'12', -family=>'Courier']);
$lb2->tagConfigure('STRG2', -foreground => "red", -font=>[-weight=>'bold', -size=>'12', -family=>'Courier']);


$entry->focus();

$penlabel->grid();
#$lastlabel->grid( );
$lb2->grid( );
$label2->grid( );
$label->grid( );
$entry->grid( );;
$label3->grid();
$lastlabel->grid();
$label10->grid();
$label5->grid( );
$frame2->grid( );
#$lb3->grid( $srl_y, $lb4 );
$lb3->grid( $lb4 );
$frame->grid();
$label9->grid();
$lb6->grid();

MainLoop;



sub enterpressed{
	
	#If nothing there
	if( $usrentry eq "" ){ exit; }
	
	my $usrentry = update();							
	
	if( $usrentry eq "leavemebreathless" ){ return; }
	
	#If nothing there
	if( $usrentry eq "" ){ exit; }
	
	#if overriden command forced
	if( $usrentry =~ m/^:/ ){
		my $custom = (split ":", $usrentry)[1];
		exec "$custom";
	}

	#if google search
	if( $usrentry =~ m/^google:/ ){
        print "google";
		my $searchq = (split "google:", $usrentry)[1];
        print "now";
		$, = "+";
		my @searchtokens = split /\s/, $searchq;
		print "<><>@searchtokens<><>\n";
		my $forceds;
		for( my $scrubs = 0; $scrubs <= $#searchtokens; $scrubs++ ){
			my $token = $searchtokens[$scrubs];  #print "<>$token<>\n";
			#$token =~ s/^\w//;                   print "<><>$token<><>\n";
			$forceds .= $token;
			$forceds .= "+";
		}
		$forceds =~ s/\+$//;
		$forceds =~ s/^\+//;
        print $forceds;
		exec "chromium --new-window \"http://www.google.com/search?q=$forceds\"";

	}	

	#if wikipedia search
	if( $usrentry =~ m/^wiki:/ ){
		my $searchq = (split "wiki:", $usrentry)[1];
		$, = "+";
		my @searchtokens = split /\s/, $searchq;
		#print "<><>@searchtokens<><>\n";
		my $forceds;
		for( my $scrubs = 0; $scrubs <= $#searchtokens; $scrubs++ ){
			my $token = $searchtokens[$scrubs];  #print "<>$token<>\n";
			#$token =~ s/^\w//;                   print "<><>$token<><>\n";
			$forceds .= $token;
			$forceds .= "+";
		}
		$forceds =~ s/\+$//;
		$forceds =~ s/^\+//;		 
		exec "chromium --new-window http://en.wikipedia.org/wiki/Special:Search?search=$forceds";
	}

	#dictionary
	if( $usrentry =~ m/^def:/ ){
		my $searchtokens = (split "def:", $usrentry)[1];    print "<>$searchtokens<>\n";
		$searchtokens =~ s/^\s//;$searchtokens =~s/^ //;	#print "<><>$searchtokens<><>\n";
		$searchtokens =~ s/\s$//;				#print "<><><>$searchtokens<><><>\n";
		exec "chromium --new-window http://dictionary.reference.com/browse/$searchtokens";
	}

	#thesaurus
	if( $usrentry =~ m/^syn:/ ){
		my $searchtokens = (split "syn:", $usrentry)[1];    #print "<>$searchtokens<>\n";
		$searchtokens =~ s/^\s//;$searchtokens =~s/^ //;	#print "<><>$searchtokens<><>\n";
		$searchtokens =~ s/\s$//;				#print "<><><>$searchtokens<><><>\n";
		exec "chromium --new-window http://thesaurus.reference.com/browse/$searchtokens";
	}

	#youtube
  	if( $usrentry =~ m/^youtube:/ ){
    		my $searchq = (split "youtube:", $usrentry)[1];
    		$, = "+";
    		my @searchtokens = split /\s/, $searchq;
    		my $forceds;
		for( my $scrubs = 0; $scrubs <= $#searchtokens; $scrubs++ ){
			my $token = $searchtokens[$scrubs];  #print "<>$token<>\n";
			#$token =~ s/^\w//;                   print "<><>$token<><>\n";
			$forceds .= $token;
			$forceds .= "+";
		}
		$forceds =~ s/\+$//;
		$forceds =~ s/^\+//;		 
		exec "chromium --new-window http://www.youtube.com/results?search_query=$forceds\&search_type=";
	}

	else{
		
		my $SCALAR = $usrentry;
			
		#look up corresponding command
			my $swim;
			my $choice;
			for( $swim = 0; $swim <= $#names; $swim++ ){
				if( $names[$swim] eq $SCALAR ){
					$choice = $swim;
				}
			}
			exec "$commands[$choice]";

	}
	got:
}

sub exitt{
	exit;
}


sub update{
	@matches = ();
	$lb2->tagRemove( "STRG",  '1.0', 'end');
	$lb2->tagRemove( "STRG2", '1.0', 'end');
	$lb2->configure( -background=>"black" );
	my $line;
	foreach my $ln(1 .. 5) {
		$line .= $lb2->get($ln.'.0', $ln.'.end');
	}

	my $adult = 0;
	my $mat = "";
	my $actual = $usrentry;
	my $usrcopy;
	if( $usrentry =~ /:/ ){ $usrcopy = (split ":", $usrentry)[0]; $usrcopy .= ":";   }
	else{ $usrcopy = $usrentry; }
	while ( $line =~ /\s+($usrcopy\S*)/g ) {
		$mat = $1;
		$adult++;
		if( $actual ne "" ){ push @matches, $mat; }
	}
	
    foreach my $ln( 1 .. 4 ){
       my $line = $lb2->get($ln.'.0', $ln.'.end');
       foreach my $el ( @matches ){
       	   while ( $line =~ /\s+($usrcopy\S*)/g ) {
       	   			if( @matches == 1 ){ 
        	        	$lb2->tagAdd('STRG2', $ln.'.'.(pos($line)-length($1)), $ln.'.'.pos($line));
        	        	#$lb2->configure( -background=>"blue" );
					}
					else{
						$lb2->tagAdd( 'STRG', $ln.'.'.(pos($line)-length($1)), $ln.'.'.pos($line));
					}
            }
       }
   }
	
	if( $adult == 1 ){
		if( $mat =~ /torrent:/ or $mat =~ /google:/ or $mat =~ /wiki:/ or $mat =~ /def:/ or $mat =~ /syn:/ or $mat =~ /youtube:/ ){
			return $actual;
		}
		
		return $mat;	
	}
	if( $actual =~ /^:/ ){ return $actual; }
	return "leavemebreathless";
}

