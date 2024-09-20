function cal {
    param (
        [int]$month = (Get-Date).Month,
        [int]$year = (Get-Date).Year,
        [switch]$ShowThreeMonths
    )

    # Función auxiliar para obtener las semanas de un mes
    function GetMonthMatrix($month, $year) {
        $matrix = @()
        $primerDia = [datetime]"$year-$month-01"
        $primerDiaSemana = (Get-Date $primerDia).DayOfWeek.value__
        $diasEnMes = [datetime]::DaysInMonth($year, $month)
        
        # Arreglo para la primera semana con espacios en blanco
        $week = @()
        for ($i = 0; $i -lt $primerDiaSemana; $i++) {
            $week += "  "
        }

        # Agregar los días del mes a las semanas
        for ($dia = 1; $dia -le $diasEnMes; $dia++) {
            $week += "{0,2}" -f $dia
            if ($week.Count -eq 7) {
                $matrix += ,$week
                $week = @()
            }
        }

        # Agregar la última semana si tiene menos de 7 días
        if ($week.Count -gt 0) {
            while ($week.Count -lt 7) {
                $week += "  "  # Añadir espacios vacíos para completar la semana
            }
            $matrix += ,$week
        }
        return $matrix
    }

    # Función para imprimir los meses alineados horizontalmente
    function PrintThreeMonths($prevMonth, $prevYear, $curMonth, $curYear, $nextMonth, $nextYear) {
        $today = Get-Date

        # Encabezados de los meses
        Write-Host ("{0,20}     {1,20}      {2,20}" -f (Get-Date "$prevYear-$prevMonth-01" -Format "MMMM yyyy").ToUpper(), (Get-Date "$curYear-$curMonth-01" -Format "MMMM yyyy").ToUpper(), (Get-Date "$nextYear-$nextMonth-01" -Format "MMMM yyyy").ToUpper()) -ForegroundColor Yellow

        # Encabezado de días de la semana
        Write-Host ("{0,20}     {1,20}      {2,20}" -f "Do Lu Ma Mi Ju Vi Sa", "Do Lu Ma Mi Ju Vi Sa", "Do Lu Ma Mi Ju Vi Sa") -ForegroundColor Yellow

        # Obtener matrices de las semanas de cada mes
        $prevMatrix = GetMonthMatrix $prevMonth $prevYear
        $curMatrix = GetMonthMatrix $curMonth $curYear
        $nextMatrix = GetMonthMatrix $nextMonth $nextYear

        # Encontrar el máximo número de semanas entre los tres meses
        $maxWeeks = [System.Math]::Max($prevMatrix.Count, [System.Math]::Max($curMatrix.Count, $nextMatrix.Count))

        # Imprimir las semanas de los tres meses
        for ($i = 0; $i -lt $maxWeeks; $i++) {
            $prevWeek = if ($i -lt $prevMatrix.Count) { $prevMatrix[$i] } else { @(" ", " ", " ", " ", " ", " ", " ") }
            $curWeek = if ($i -lt $curMatrix.Count) { $curMatrix[$i] } else { @(" ", " ", " ", " ", " ", " ", " ") } 
            $nextWeek = if ($i -lt $nextMatrix.Count) { $nextMatrix[$i] } else { @(" ", " ", " ", " ", " ", " ", " ") }

            # Imprimir las tres semanas en la misma línea
            $prevLine = ($prevWeek -join " ")
            $curLine = ""
            $nextLine = ($nextWeek -join " ")

            # Revisar los días de la semana actual y resaltar si coincide con el día actual
            for ($j = 0; $j -lt 7; $j++) {
                if (($curWeek[$j].Trim() -eq $today.Day.ToString()) -and ($curMonth -eq $today.Month) -and ($curYear -eq $today.Year)) {
                    # Imprimir el día actual en rojo
                    $curLine += ("{0,2} " -f $curWeek[$j]) -replace " ", "`t"
                    Write-Host -NoNewline -ForegroundColor Red ("{0,2} " -f $curWeek[$j])
                } else {
                    $curLine += "{0,2} " -f $curWeek[$j]
                }
            }

            Write-Host ("{0,20}     {1,20}      {2,20}" -f $prevLine, $curLine, $nextLine)
        }
    }

    # Mostrar tres meses si el parámetro -ShowThreeMonths está activado
    if ($ShowThreeMonths) {

        $prevMonth = if ($month -eq 1) { 12 } else { $month - 1 }
        $prevYear = if ($month -eq 1) { $year - 1 } else { $year }

        $nextMonth = if ($month -eq 12) { 1 } else { $month + 1 }
        $nextYear = if ($month -eq 12) { $year + 1 } else { $year }

        PrintThreeMonths $prevMonth $prevYear $month $year $nextMonth $nextYear
        
    } else {
        # Código original para mostrar un solo mes
        $matrix = GetMonthMatrix $month $year
        Write-Host ("{0,20}" -f (Get-Date "$year-$month-01" -Format "MMMM yyyy")).ToUpper() -ForegroundColor Yellow
        Write-Host "Do Lu Ma Mi Ju Vi Sa" -ForegroundColor Yellow
        foreach ($week in $matrix) {
            Write-Host ($week -join " ")
        }
    }
}
