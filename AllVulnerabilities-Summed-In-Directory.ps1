## Authored by: Jean-Luc DeJean
## Purpose: To grab the total amount of CAT I, II, III   from a directory of checklists.
## Output: Script outputs a .txt file in C:\Temp\ with totals         


## MAKE CHANGES HERE IF NEEDED ##

$DirPath = ""  ## Provide the directory of checklists to look through

$OutputType = "CSV"   ## .txt output by default

## END MAKE CHANGES SECTION ##




















## Formatting output file
$TodayDate = Get-date -Format yyyy-MM-dd-ss

$Outfilename = "Combined-CCRI-Totals-From-Checklists-" + $TodayDate + ".txt"

$OutputPath = "C:\Temp\" + $Outfilename

$ALLCKLItems = Get-childitem -Path $DirPath -Filter "*.ckl" -Name

if (Test-Path $DirPath){
cd $DirPath
}
else {

write-host "Invalid path provided. Please provide a valid path and re-run script."
break

}


## Global items to be used in the 2nd function that's called:
$TotalCatI = 0
$TotalCatII = 0
$TotalCatIII = 0
$TotalChecklists = $AllCklItems.Length

$TotalCatIOpen = 0
$TotalCatIIOpen = 0
$TotalCatIIIOpen = 0

$TotalCatINotApplicable = 0
$TotalCatIINotApplicable = 0
$TotalCatIIINotApplicable = 0




[System.Collections.ArrayList]$IndivItemObj = @()
[System.Collections.ArrayList]$AllItemObj = @()


## This function pulls totals from each indivdiual checklist
function Get-CKLTotals{

Foreach ($DiffCKL in $AllCklItems){

write-host -ForegroundColor Green "Pulling vulnerability item information from $DiffCKL....."

[XML]$CKLdata = Get-Content $DiffCKL ## Create XML object for individual checklist item

$Eachvuln = $CKLData.Checklist.STIGs.iSTIG.VULN ## Grab each vulnerability from XML .ckl file and store in variable.

$ChecklistCatIII = 0
$ChecklistCatII = 0
$ChecklistCatI = 0
$ChecklistCatIIIOpen = 0
$ChecklistCatIIOpen = 0
$ChecklistCatIOpen = 0
$ChecklistCatIIINotApplicable = 0
$ChecklistCatIINotApplicable = 0
$ChecklistCatINotApplicable = 0

foreach ($Diffvuln in $Eachvuln){

$Childnodes = $DiffVuln.ChildNodes

$VulnSeverity = $Childnodes.Item(1).Attribute_Data


if ($VulnSeverity -eq "Low"){
$ChecklistCatIII += 1
}

if ($VulnSeverity -eq "Medium"){
$ChecklistCatII += 1
}

if ($VulnSeverity -eq "High"){
$ChecklistCatI += 1
}

## IF OPEN
if ($DiffVuln.Status -eq "Open"){

if ($VulnSeverity -eq "Low"){
$ChecklistCatIIIOpen += 1
}

if ($VulnSeverity -eq "Medium"){
$ChecklistCatIIOpen += 1
}

if ($VulnSeverity -eq "High"){
$ChecklistCatIOpen += 1
}



} ## END OF IF OPEN



if ($DiffVuln.Status -eq "Not_Applicable"){

if ($VulnSeverity -eq "Low"){
$ChecklistCatIIINotApplicable += 1
}

if ($VulnSeverity -eq "Medium"){
$ChecklistCatIINotApplicable += 1
}

if ($VulnSeverity -eq "High"){
$ChecklistCatINotApplicable += 1
}

} ## end if not applicable




} ## end of child foreach

write-output "$DiffCKL Checklist Totals - " >> $OutputPath
write-output "Total Cat I: $ChecklistCatI    Total Open Cat I: $ChecklistCatIOpen      Total Not_Applicable Cat I: $ChecklistCatINotApplicable" >> $OutputPath  ## Also write the open items totals
write-output "Total Cat II: $ChecklistCatII    Total Open Cat II: $ChecklistCatIIOpen        Total Not_Applicable Cat II: $ChecklistCatIINotApplicable" >> $OutputPath
write-output "Total Cat III: $ChecklistCatIII    Total Open Cat III: $ChecklistCatIIIOpen      Total Not_Applicable Cat III: $ChecklistCatIIINotApplicable" >> $OutputPath


} ## end of parent foreach


} ##end of function


## Pulls the TOTALS from all checklists 
function Get-CKLNumbers {

Foreach ($DiffCKL in $AllCklItems){

write-host -ForegroundColor Cyan "Pulling totals data from $DiffCKL....."

[XML]$CKLdata = Get-Content $DiffCKL ## Create XML object for individual checklist item

$Eachvuln = $CKLData.Checklist.STIGs.iSTIG.VULN ## Grab each vulnerability from XML .ckl file and store in variable.


foreach ($Diffvuln in $Eachvuln){

$Childnodes = $DiffVuln.ChildNodes

$VulnSeverity = $Childnodes.Item(1).Attribute_Data

if ($VulnSeverity -eq "Low"){
$TotalCatIII += 1
}

if ($VulnSeverity -eq "Medium"){
$TotalCatII += 1
}

if ($VulnSeverity -eq "High"){
$TotalCatI += 1
}

## If status Open
if ($DiffVuln.Status -eq "Open"){

if ($VulnSeverity -eq "Low"){
$TotalCatIIIOpen += 1
}

if ($VulnSeverity -eq "Medium"){
$TotalCatIIOpen += 1
}

if ($VulnSeverity -eq "High"){
$TotalCatIOpen += 1
}





}  ## end of if status open

if ($DiffVuln.Status -eq "Not_Applicable"){

if ($VulnSeverity -eq "Low"){
#$ChecklistCatIIINotApplicable += 1
$TotalCatIIINotApplicable += 1
}

if ($VulnSeverity -eq "Medium"){
#$ChecklistCatIINotApplicable += 1
$TotalCatIINotApplicable += 1

}

if ($VulnSeverity -eq "High"){
#$ChecklistCatINotApplicable += 1
$TotalCatINotApplicable += 1

}

}

} ## end of child foreach

} ## end of foreach different ckl


write-output "Directory of checklists selected: $DirPath `r`n" >> $OutputPath
write-output "SUMMARY:" >> $OutputPath
write-output "--------------------------------------------" >> $OutputPath
write-output "The total amount of Checklists: $TotalChecklists" >> $OutputPath
write-output "The total number of Cat Is: $TotalCatI    Total Open Cat I: $TotalCatIOpen     Total NotApplicable Cat I: $TotalCatINotApplicable" >> $OutputPath
write-output "The total number of Cat IIs: $TotalCatII    Total Open Cat II: $TotalCatIIOpen     Total NotApplicable Cat II: $TotalCatIINotApplicable" >> $OutputPath
write-output "The total number of Cat IIIs: $TotalCatIII    Total Open Cat III: $TotalCatIIIOpen     Total NotApplicable Cat III: $TotalCatIIINotApplicable" >> $OutputPath
write-output "--------------------------------------------" >> $OutputPath
write-output "Individual Checklist Details:`r`n" >> $OutputPath


} ## end function


Get-CKLNumbers
Get-CKLTotals

if (Test-Path $OutputPath){

write-host -ForegroundColor Yellow "Output file has been created here $OutputPath"

}
else {

write-host -ForegroundColor Yellow "Unable to output file. Can you verify that $Outputpath is a valid filepath and re-run this script?"

}