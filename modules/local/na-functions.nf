def saveContigs(Map args){
    if (!args.filename.endsWith('.version.txt')) {
        if (args.filename.endsWith('.fa')){
            return [args.publish_dir, args.meta.id + '.contigs.fa'].join('/')
        }
        if (args.filename.endsWith('.log')){
             return [args.publish_dir, args.meta.id + '.log'].join('/')
        }

    }


}