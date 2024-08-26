$StopWhenPoor = $true #does nothing at this time

$MaxRollCount =    40 #number of 'shooters/points' that will be ran per run
[int32]$BankRoll =     2500 
$PlaceFive =  @(100, 50, 25, 25)
$PlaceSix =   @(120, 60, 30, 30)
$placeEight = @(120, 60, 30, 30)
$placeNine =  @(100, 50, 25, 25)

$PaySixEight = 7/6
$payFiveNine =  7/5

function Roll-Dice {
    param (
        [int32]$DiceNumber = 2,
        [int32]$DiceSides = 6
    )

    $TotalRolled = 0
    for ( $Die = 0; $Die -lt $DiceNumber; $Die++){
        $Roll = ((Get-Random) % $DiceSides ) + 1
        $TotalRolled = $TotalRolled + $Roll
       #Write-Host "Die#: $Die Roll: $Roll Total: $TotalRolled"
    }

    Write-Output $TotalRolled
}

#Roll-Dice -DiceNumber 2 -DiceSides 6

for ($shooter = 0; $shooter -lt $MaxRollCount -and $BankRoll -gt 0; $shooter++ ) {
    Write-Host "Shooter# $shooter Bankroll Value: $BankRoll"
    $ComeOut = 0 # Comeout = 0 for OFF, 1 for ON
    $notSevenOut = $true # True is live roll, False is shooter done
    $point = 0 #Clear last roll/point info
    
    
    While ($point -eq 0){ # Set the point
        $DiceRoll = Roll-Dice
        If ($DiceRoll -lt 4 -or $DiceRoll -gt 10 -or $DiceRoll -eq 7){
            $point = 0 #no point set on Craps, 7 or 11
        } Else {
            $point = $DiceRoll
        }
    }

    $CurrRollCount = 0

    While ($notSevenOut){
        $currentWager = 0 #place bets
        If ($CurrRollCount -lt $placeEight.length){
            $currentWager = ( $placeEight[$CurrRollCount] + $PlaceFive[$CurrRollCount] + $PlaceSix[$CurrRollCount] + $placeNine[$CurrRollCount] )
            $BankRoll = $Bankroll - $currentWager
        } else {
            $currentWager = ($placeEight[-1]+$PlaceFive[-1]+$PlaceSix[-1]+$placeNine[-1])
            $BankRoll = $Bankroll - $currentWager
        }

        $DiceRoll = Roll-Dice
        If ($DiceRoll -gt 4 -or $DiceRoll -lt 10) {
           # Write-Host "RollCount: $CurrRollCount Dice Value: $DiceRoll"
            if ($DiceRoll -eq 7) {
                $notSevenOut = $false # Seven Out, Line Away, Bye bye
               # Write-Host "Lost: $CurrentWager"            
            } Elseif ($DiceRoll -eq 6) {
                If ($CurrRollCount -lt $PlaceSix.length){
                    $RollWinAmt = $PlaceSix[$CurrRollCount] * $PaySixEight
                    $BankRoll = $BankRoll + $currentWager + $RollWinAmt
                } Else {
                    $RollWinAmt = $PlaceSix[-1] * $PaySixEight
                    $BankRoll = $BankRoll + $currentWager + $RollWinAmt
                }                
            } elseif ($DiceRoll -eq 8) {
                If ($CurrRollCount -lt $placeEight.length){
                    $RollWinAmt = $placeEight[$CurrRollCount] * $PaySixEight
                    $BankRoll = $BankRoll + $currentWager + $RollWinAmt
                } Else {
                    $RollWinAmt = $placeEight[-1] * $PaySixEight
                    $BankRoll = $BankRoll + $currentWager + $RollWinAmt
                } 
            } elseif ($DiceRoll -eq 5) {
                If ($CurrRollCount -lt $PlaceFive.length){
                    $RollWinAmt = $PlaceFive[$CurrRollCount] * $payFiveNine
                    $BankRoll = $BankRoll + $currentWager + $RollWinAmt
                } Else {
                    $RollWinAmt = $PlaceFive[-1] * $payFiveNine
                    $BankRoll = $BankRoll + $currentWager + $RollWinAmt
                } 
            } else { #only number left is 9
                If ($CurrRollCount -lt $placeNine.length){
                    $RollWinAmt = $placeNine[$CurrRollCount] * $payFiveNine
                    $BankRoll = $BankRoll + $currentWager + $RollWinAmt
                } Else {
                    $RollWinAmt = $placeNine[-1] * $payFiveNine
                    $BankRoll = $BankRoll + $currentWager + $RollWinAmt
                } 
            }

            $CurrRollCount++
        }

    }
        
    }
    












