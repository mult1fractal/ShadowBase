/*******************************************************
 * ShadowBase // MESSAGES
 *******************************************************/

def helpMSG() {
    def c_pink   = "\033[1;35m"
    def c_cyan   = "\033[1;36m"
    def c_yellow = "\033[1;33m"
    def c_dim    = "\033[2;37m"
    def c_reset  = "\033[0m"

    log.info """
    ${c_cyan}╔═════════════════════════════════════════════════════╗
    ║                   ${c_pink}SHADOW BASE${c_cyan}                       ║
    ╚═════════════════════════════════════════════════════╝${c_reset}
    
    ${c_pink}[:: USAGE EXAMPLES ::]${c_reset}

    ${c_dim}> Single Sample Input:${c_reset}
    nextflow run main.nf --fasta_ref ref.fasta --bam sample.bam --output results -profile local,docker

    ${c_dim}> Multi Sample Input (multi reference):${c_reset}
    nextflow run main.nf --samples samples.csv --output results -profile local,docker

    ${c_pink}[:: INPUT PARAMETERS ::]${c_reset}
    --fasta_ref         ${c_yellow}'*.fasta'${c_reset}   -> reference fasta file
    --bam               ${c_yellow}'*.bam'${c_reset}     -> BAM file with modifications
    --samples           ${c_yellow}'*.csv'${c_reset}     -> CSV file (name,bam,fasta)

    ${c_pink}[:: OPTIONS ::]${c_reset}
    --cores             max cores per process [default: $params.cores]
    --max_cores         max cores used on the machine [default: $params.max_cores]    
    --output            name of the result folder [default: $params.output]

    ${c_pink}[:: PROFILES & ENGINES ::]${c_reset}
    Execute via profile configurations: ${c_cyan}-profile <Executor>,<Engine>${c_reset}
    
    ${c_cyan}[ EXECUTORS ]${c_reset}  -> slurm | local | lsf
    ${c_pink}[ ENGINES ]${c_reset}    -> docker | singularity
    """.stripIndent()
}

def defaultMSG() {
    def c_pink   = "\033[1;35m"
    def c_cyan   = "\033[1;36m"
    def c_green  = "\033[1;32m"
    def c_yellow = "\033[1;33m"
    def c_dim    = "\033[2;37m"
    def c_reset  = "\033[0m"

    log.info """
${c_cyan}      ▀▀▀▀▀▀ ▀▀▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀ ▀▀▀ ▀▀ ▀▀ ▀ ▀${c_reset}
${c_pink}         ____  _                 _               
        / ___|| |__   __ _  __| | _____      __
        \\___ \\| '_ \\ / _` |/ _` |/ _ \\ \\ /\\ / /
         ___) | | | | (_| | (_| | (_) \\ V  V / 
        |____/|_| |_|\\__,_|\\__,_|\\___/ \\_/\\_/  
              ____                      
             | __ )  __ _ ___  ___      
             |  _ \\ / _` / __|/ _ \\     
             | |_) | (_| \\__ \\  __/     
             |____/ \\__,_|___/\\___|     ${c_reset}
${c_cyan}      ▄▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄ ▄▄▄▄ ▄▄▄ ▄▄▄ ▄▄ ▄▄ ▄ ▄${c_reset}

${c_cyan}[:: SHADOW BASE :: WORKFLOW INFORMATION ::]${c_reset}
${c_green}» Profile:${c_reset}           ${workflow.profile}
${c_green}» Current User:${c_reset}      ${workflow.userName}
${c_green}» Nextflow Version:${c_reset}  v${nextflow.version}
${c_green}» Start Time:${c_reset}        ${nextflow.timestamp}

${c_pink}[:: DIRECTORIES ::]${c_reset}
${c_yellow}» Results Dir:${c_reset}       ${params.output}
${c_yellow}» Work Dir:${c_reset}          ${workflow.workDir}

${c_cyan}[:: WORKFLOW STEPS ::]${c_reset}
${c_dim}» Motif Calling:.......${c_reset}  ${c_green}[ ENABLED ]${c_reset}

${c_cyan}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${c_reset}
"""
}

def progressBar(workflow) {
    def c_pink   = "\033[1;35m"
    def c_cyan   = "\033[1;36m"
    def c_reset  = "\033[0m"
    def c_dim    = "\033[2;37m"

    def completed = workflow.stats.succeededCount + workflow.stats.cachedCount + workflow.stats.failedCount
    def total     = workflow.stats.submittedCount
    
    if (total > 0) {
        def percent = (completed * 100.0) / total
        def width   = 40
        def done    = (int) (percent / 100 * width)
        def remain  = width - done
        
        def bar = "${c_pink}" + "█" * done + "${c_dim}" + "░" * remain + "${c_reset}"
        
        print "\r${c_cyan}[ WORKFLOW PROGRESS ]${c_reset} ${bar} ${c_cyan}${String.format('%.1f', percent)}%${c_reset} ${c_dim}[${completed}/${total}]${c_reset}"
        if (completed == total) println ""
    }
}
