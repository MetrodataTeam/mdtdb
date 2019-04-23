cat > $PGDATA/pipelinedb.conf << EOF
shared_preload_libraries = 'pipelinedb,pipeline_kafka'
max_worker_processes = 128
EOF

echo "include 'pipelinedb.conf'" >> $PGDATA/postgresql.conf
