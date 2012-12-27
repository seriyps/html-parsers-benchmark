<?php
/**
 * Created on 2012-12-27
 * @author: Keksov <keksov@gmail.com>
 */
set_time_limit(0);

$file  = $argv[1];
$count = $argv[2];

$html = file_get_contents( $file );
if ( $html === false ) 
{
    file_put_contents( 'php://stderr', 'Unable to read file: '.$file );
    exit;
}

if ( !ctype_digit( $count ) )
{
    file_put_contents( 'php://stderr', 'Wrong count value: '.$count );
    exit;
}

$time_start = microtime( true );
run_loop( $html, $count );
$loop_time = time( true ) - $time_start;
echo "$loop_time\n";

function run_loop( $aHtml, $aCount )
{
    for ( $i = 0; $i < $aCount; $i++ )
    {
        $tidy = new tidy();
        $tidy->parseString( $aHtml, array(
            'output-xml'       => true,
            'clean'            => true,
            'numeric-entities' => true
        ), 'utf8' );

        $tidy->cleanRepair();
        //echo tidy_get_output( $tidy );
        
        $xml = simplexml_load_string( tidy_get_output( $tidy ) );
        if ( $xml === false )
        {
            file_put_contents( 'php://stderr', 'Unable to parse file' );
            return;
        }
        
        unset( $xml );
        unset( $tidy );
    }
}

?>