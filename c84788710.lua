--竜の骸歌
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:GetLevel()>0 and c:IsRace(RACE_INSECT+RACE_DRAGON) and c:IsAbleToDeck()
end
function s.rfilter(c,e,tp,mg)
	if not c:IsRace(RACE_INSECT) or not c:IsType(TYPE_RITUAL)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg2=mg:Clone()
	if c.mat_filter then
		mg2=mg:Filter(c.mat_filter,nil,tp)
	end
	return s.rgreater(mg2,c:GetLevel(),c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return false end
		local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function s.gcheck(g,mg)
	local res=false
	local lv=g:GetSum(Card.GetLevel)
	for tc in aux.Next(g) do
		if s.rgreater(mg,lv,tc) then
			return true
		end
	end
	return false
end
function s.rsgcheck(g,sg)
	local res=false
	local lv=sg:GetSum(Card.GetLevel)
	for tc in aux.Next(sg) do
		Duel.SetSelectedCard(g)
		if g:CheckWithSumGreater(Card.GetRitualLevel,lv,tc) then
			return true
		end
	end
	return false
end
--Material checks. On a big GY two searches hang:
--mg:SelectSubGroup(tp,s.rsgcheck,true,1,99,rg) with the Ritual Monsters rg
--tries every superset of every partial group, and
--mg:CheckWithSumGreater(Card.GetRitualLevel,lv,tc) keeps searching after the
--sum overshoots. s.rgreater answers the same as the latter, and s.rselect asks
--the same prompts as the former with its candidates found directly
--(s.rcandidates); both count with s.rcan.

--the levels mc can count as for tc (Card.GetRitualLevel): {lv} or {lv1,lv2}
function s.rlevels(mc,tc)
	local v=mc:GetRitualLevel(tc)
	local lo=v&0xffff
	local hi=v>>16
	if hi==0 or hi==lo then return {lo} end
	return {lo,hi}
end
--whether rsgcheck passes for some group of all of must plus any of more,
--each card counted as one of its levels: sum>=lv and sum-min<lv, i.e. for a
--floor m (the least level counted) every level is >= m and the sum is in
--[lv,lv+m-1]
function s.rcan(must,more,lv)
	local floors={}
	for _,t in ipairs({must,more}) do
		for _,ls in ipairs(t) do
			for _,v in ipairs(ls) do floors[v]=true end
		end
	end
	for m in pairs(floors) do
		--reach[n]: the cards so far can sum to n (more than top never helps)
		local top=lv+m-1
		local reach={[0]=true}
		for _,ls in ipairs(must) do
			local nr={}
			for n=0,top do
				if reach[n] then
					for _,v in ipairs(ls) do
						if v>=m and n+v<=top then nr[n+v]=true end
					end
				end
			end
			reach=nr
		end
		--cards with one usable level by count (used[n]: copies of v that
		--reach n), cards with two one by one
		local count,two={},{}
		for _,ls in ipairs(more) do
			local a,b=ls[1],ls[2]
			if a<m then a=nil end
			if b and b<m then b=nil end
			if a and b then
				two[#two+1]=ls
			elseif a or b then
				local v=a or b
				count[v]=(count[v] or 0)+1
			end
		end
		for v,k in pairs(count) do
			local used={}
			for n=0,top do
				if reach[n] then
					used[n]=0
				elseif n>=v and reach[n-v] and used[n-v]<k then
					reach[n]=true
					used[n]=used[n-v]+1
				end
			end
		end
		--downwards, so each card adds at most once
		for _,ls in ipairs(two) do
			for n=top,0,-1 do
				if reach[n] then
					for _,v in ipairs(ls) do
						if v>=m and n+v<=top then reach[n+v]=true end
					end
				end
			end
		end
		for n=lv,top do
			if reach[n] then return true end
		end
	end
	return false
end
--mg:CheckWithSumGreater(Card.GetRitualLevel,lv,tc): some group of mg sums to
--at least lv and drops below lv without its least card
function s.rgreater(mg,lv,tc)
	local more={}
	for mc in aux.Next(mg) do more[#more+1]=s.rlevels(mc,tc) end
	return s.rcan({},more,lv)
end
--the cards of mg not in sg that are in some group passing rsgcheck with all
--of sg: the cg SelectSubGroup's search captures, as it does not depend on the
--search order. lvs[tc][mc] holds s.rlevels; cards with the same key (the
--same levels for every Ritual Monster) agree.
function s.rcandidates(mg,sg,rg,lvs,keys,lv)
	local cg=Group.CreateGroup()
	--arrays: aux.Next keeps its place in the group, so no nested loops on one
	local pool,sel={},{}
	for mc in aux.Next(mg-sg) do pool[#pool+1]=mc end
	for mc in aux.Next(sg) do sel[#sel+1]=mc end
	local known={}
	for _,mc in ipairs(pool) do
		local ok=known[keys[mc]]
		if ok==nil then
			ok=false
			for tc in aux.Next(rg) do
				local must,more={lvs[tc][mc]},{}
				for _,c in ipairs(sel) do must[#must+1]=lvs[tc][c] end
				for _,c in ipairs(pool) do
					if c~=mc then more[#more+1]=lvs[tc][c] end
				end
				if s.rcan(must,more,lv) then
					ok=true
					break
				end
			end
			known[keys[mc]]=ok
		end
		if ok then cg:AddCard(mc) end
	end
	return cg
end
--Group.SelectSubGroup's loop for mg:SelectSubGroup(tp,s.rsgcheck,true,1,99,rg)
function s.rselect(mg,tp,rg)
	local min,max=1,99
	local lv=rg:GetSum(Card.GetLevel)
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or #(mg+fg)<min then return nil end
	--nothing changes while the materials are selected
	local lvs,keys={},{}
	for tc in aux.Next(rg) do lvs[tc]={} end
	for mc in aux.Next(mg+fg) do
		local parts={}
		for tc in aux.Next(rg) do
			local ls=s.rlevels(mc,tc)
			lvs[tc][mc]=ls
			parts[#parts+1]=table.concat(ls,"/")
		end
		keys[mc]=table.concat(parts,",")
	end
	for _ in aux.Next(fg) do
		fg:SelectUnselect(sg,tp,false,false,min,max)
	end
	sg:Merge(fg)
	local finish=(#sg>=min and #sg<=max and s.rsgcheck(sg,rg))
	while #sg<max do
		local cg=s.rcandidates(mg,sg,rg,lvs,keys,lv)
		finish=(#sg>=min and #sg<=max and s.rsgcheck(sg,rg))
		if #cg==0 then break end
		local cancel=not finish
		local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
		if not tc then break end
		if not fg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==max then finish=true end
			else
				sg:RemoveCard(tc)
			end
		else
			return nil
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft==0 then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local tg=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND,0,nil,e,tp,mg)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=tg:SelectSubGroup(tp,s.gcheck,false,1,ft,mg)
	if sg:GetCount()>0 then
		for tc in aux.Next(sg) do
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local mat=s.rselect(mg,tp,sg)
		if not mat then goto cancel end
		for tc in aux.Next(sg) do
			tc:SetMaterial(mat)
		end
		Duel.HintSelection(mat)
		Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		for tc in aux.Next(sg) do
			tc:CompleteProcedure()
		end
	end
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_INSECT) and c:IsAbleToGraveAsCost()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and aux.NecroValleyFilter()(c) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
