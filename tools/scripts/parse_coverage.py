results = {}
current_file = None
total_lines = 0
hit_lines = 0
uncovered = []

with open('coverage/lcov.info') as f:
    for line in f:
        line = line.rstrip('\n\r')
        if line.startswith('SF:'):
            path = line[3:]
            path = path.replace('\', '/')
            current_file = path
            total_lines = 0
            hit_lines = 0
            uncovered = []
        elif line.startswith('DA:') and current_file:
            parts = line[3:].split(',')
            if len(parts) >= 2:
                lineno = int(parts[0])
                hits = int(parts[1])
                total_lines += 1
                if hits > 0:
                    hit_lines += 1
                else:
                    uncovered.append(lineno)
        elif line == 'end_of_record' and current_file:
            if 'lib/providers/' in current_file:
                basename = current_file.split('/')[-1]
                if not basename.endswith('.g.dart') and not basename.endswith('.freezed.dart'):
                    pct = round(hit_lines / total_lines * 100, 1) if total_lines > 0 else 0.0
                    results[basename] = {'coverage_pct': pct, 'uncovered_lines': uncovered[:], 'total': total_lines, 'hit': hit_lines}
            current_file = None

for k, v in sorted(results.items()):
    print(f"{v['coverage_pct']:6.1f}%  {v['hit']:3d}/{v['total']:3d}  {k}")
print(f'Total: {len(results)} providers')
