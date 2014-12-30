#!/usr/bin/perl -w

while(<>){
    chomp;
    @line = split(/\t/,$_);
    if($metmatch{$line[1]}{$line[8]}){
	$lastmatch = abs(length($metmatch{$line[1]}{$line[8]}) - length($line[8]));
	$thismatch = abs(length($line[0]) - length($line[8]));
	if($thismatch < $lastmatch){
	    $metmatch{$line[1]}{$line[8]} = $line[0];
	}
    }
    else{$metmatch{$line[1]}{$line[8]} = $line[0];
	 $mettotal{$line[1]}++;
	 $metcountclass{$line[1]}{$line[7]}{$line[4]}++; 
	 $metcountdirectparent{$line[1]}{$line[7]}{$line[5]}++;
	 $metcountsuperclass{$line[1]}{$line[7]}{$line[3]}++;
	 $metscoretotal{$line[1]}{$line[7]}++;
    }
}

#open(BEGINNING,"barbaras_tooscaredtoask_file.berries.metabolites_clean_noAAs.txt");
open(BEGINNING,"metabolites_wine_finished_noAAs.tab");
@begin_file = <BEGINNING>;
close(BEGINNING);

for(@begin_file){
    chomp;
    @line = split(/\t/,$_);
    $beginmetcounts{$line[0]}++;
}

print "metabolite\ttotal.queries\ttotal.in.0.0\tsuper.class.winner0.0\tsuper.class.count0.0\tclass.winner0.0\tclass.count0.0\tdirect.parent.winner0.0\tdirect.parent.count0.0\ttotal.in.0.1\tsuper.class.winner0.1\tsuper.class.count0.1\tclass.winner0.1\tclass.count0.1\tdirect.parent.winner0.1\tdirect.parent.count0.1\ttotal.in.0.2\tsuper.class.winner0.2\tsuper.class.count0.2\tclass.winner0.2\tclass.count0.2\tdirect.parent.winner0.2\tdirect.parent.count0.2\ttotal.in.0.3\tsuper.class.winner0.3\tsuper.class.count0.3\tclass.winner0.3\tclass.count0.3\tdirect.parent.winner0.3\tdirect.parent.count0.3\ttotal.in.all\tsuper.class.winner.global\tsuper.class.count.global\tclass.winner.global\tclass.count.global\tdirect.parent.winner.global\tdirect.parent.count.global";

@scores = (0,0.1,0.2,0.3);
foreach my $metabolite (sort keys %mettotal){
    print join "","\n",$metabolite,"\t",$beginmetcounts{$metabolite},"\t";
    my $record = 0;
    my $besthit = 0;
    my (@best_super_class,@best_class,@best_direct_parent,@best_super_class_count,@best_class_count,@best_direct_parent_count,@total_counted);
    foreach my $score (@scores){
	if($metscoretotal{$metabolite}{$score}){	
    	    $best{$metabolite} = $score+1 if($besthit == 0);
	    $besthit = 1;
	    $total_in_score[$record] = $metscoretotal{$metabolite}{$score};
	    $total_counted[$record] += $total_in_score[$record];
	     ($best_super_class_count[$record],$best_class_count[$record],$best_direct_parent_count[$record]) = (0,0,0);
	    foreach my $super_class (sort keys %{$metcountsuperclass{$metabolite}{$score}}){
		$newbest_super_class_count = $metcountsuperclass{$metabolite}{$score}{$super_class};
		if($newbest_super_class_count > $best_super_class_count[$record]){
		    $best_super_class_count[$record] = $newbest_super_class_count;
		    $best_super_class[$record] = $super_class;
		}elsif($newbest_super_class_count == $best_super_class_count[$record]){
                    $best_super_class_count[$record] +=$newbest_super_class_count;
                    $best_super_class[$record]= join " AND ",$best_super_class[$record],$super_class;
                }
	    }
	    print join "\t",$total_in_score[$record],$best_super_class[$record],$best_super_class_count[$record];print "\t";
	    foreach my $class (sort keys %{$metcountclass{$metabolite}{$score}}){
		$newbest_class_count = $metcountclass{$metabolite}{$score}{$class};
		if($newbest_class_count > $best_class_count[$record]){
		    $best_class_count[$record] = $newbest_class_count;
		    $best_class[$record] = $class;
		}elsif($newbest_class_count == $best_class_count[$record]){
		    $best_class_count[$record] += $newbest_class_count;
		    $best_class[$record] = join " AND ",$best_class[$record],$class;
		}
	    }
	    print join "\t",$best_class[$record],$best_class_count[$record];print "\t";
	    foreach my $direct_parent ( sort keys %{$metcountdirectparent{$metabolite}{$score}}){
		$newbest_direct_parent_count = $metcountdirectparent{$metabolite}{$score}{$direct_parent};
		if($newbest_direct_parent_count > $best_direct_parent_count[$record]){
		    $best_direct_parent_count[$record] = $newbest_direct_parent_count;
		    $best_direct_parent[$record] = $direct_parent;
		}elsif($newbest_direct_parent_count == $best_direct_parent_count[$record]){
                    $best_direct_parent_count[$record] +=$newbest_direct_parent_count;
                    $best_direct_parent[$record] = join " AND ",$best_direct_parent[$record],$direct_parent;
		}
	    }
	    print join "\t",$best_direct_parent[$record],$best_direct_parent_count[$record];print "\t";
	    
	}else{
	    print "-\t-\t-\t-\t-\t-\t-\t";
	}
	$record++;
    }
    my ($winner_dp_count,$winner_sc_count,$winner_c_count,$count,$add_on_dp,$add_on_sc,$add_on_c) = (0,0,0,0,"","","");
    my $totalcount = 0;
    foreach my $score (@scores){
	if(($best{$metabolite})  && ($best{$metabolite}== $score+1)){
	    $winner_dp_count = $best_direct_parent_count[$count];
	    $winner_dp = $best_direct_parent[$count];
	    $winner_sc_count = $best_super_class_count[$count];
	    $winner_sc = $best_super_class[$count];
	    $winner_c_count = $best_class_count[$count];
	    $winner_c = $best_class[$count];
	    $totalcount = $total_in_score[$count];
	}elsif( defined($best_direct_parent[$count]) && ($best{$metabolite} < $score+1)){
	    $winner_dp_count += $best_direct_parent_count[$count] if($best_direct_parent[$count] eq $winner_dp);
	    $add_on_dp .= "+" if(($winner_dp_count < $best_direct_parent_count[$count]) && !($best_direct_parent[$count] eq $winner_dp));
	    $winner_sc_count += $best_super_class_count[$count] if($best_super_class[$count] eq $winner_sc);
            $add_on_sc .= "+" if(($winner_sc_count < $best_super_class_count[$count]) && !($best_super_class[$count] eq $winner_sc));
	    $winner_c_count += $best_class_count[$count] if($best_class[$count] eq $winner_c);
            $add_on_c .= "+" if(($winner_c_count < $best_class_count[$count]) && !($best_class[$count] eq $winner_dp));
	    $totalcount += $total_in_score[$count];
	}
	$count++;
    }
    $winner_dp_count .= $add_on_dp;
    $winner_sc_count .= $add_on_sc;
    $winner_c_count .= $add_on_c;
    if($best{$metabolite}){
	print join "\t",$totalcount,$winner_sc,$winner_sc_count,$winner_c,$winner_c_count,$winner_dp,$winner_dp_count;
    }
    else{print "\t-\t-\t-\t-\t-\t-\t-";}
}
