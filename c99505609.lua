--ビンゴカード
local s,id,o=GetID()
function s.initial_effect(c)
	--destroy column
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.actg)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1)
	--destroy zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end
function s.colfilter(c)
	if not (c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)) then return false end
	-- there're bugs in IsAllColumn, when the column is full, it returns false
	if c:GetSequence()>=5 then
		return c:GetColumnGroupCount()==4
	end
	return c:IsAllColumn()
end
function s.zonefilter(c)
	return c:GetSequence()<5
end
function s.fullmzone(p)
	return Duel.GetMatchingGroup(s.zonefilter,p,LOCATION_MZONE,0,nil):GetCount()==5
end
function s.fullszone(p)
	return Duel.GetMatchingGroup(s.zonefilter,p,LOCATION_SZONE,0,nil):GetCount()==5
end
function s.canrow(p)
	return (s.fullmzone(p) or s.fullszone(p)) and Duel.IsPlayerCanDraw(p,2)
end
function s.rowdesgroup(p)
	local g=Group.CreateGroup()
	if s.fullmzone(p) then
		g:Merge(Duel.GetMatchingGroup(s.zonefilter,p,LOCATION_MZONE,0,nil))
	end
	if s.fullszone(p) then
		g:Merge(Duel.GetMatchingGroup(s.zonefilter,p,LOCATION_SZONE,0,nil))
	end
	return g
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.colfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	local g=Group.CreateGroup()
	local rg=Duel.GetMatchingGroup(s.colfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(rg) do
		g:Merge(tc:GetColumnGroup())
		g:AddCard(tc)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.colfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	Duel.HintSelection(g)
	local dg=tc:GetColumnGroup()
	dg:Merge(g)
	if dg:GetCount()>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=s.canrow(tp)
	local b2=s.canrow(1-tp)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2),1},
		{b2,aux.Stringid(id,3),2})
	e:SetLabel(op)
	local p=op==1 and tp or 1-tp
	local g=s.rowdesgroup(p)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,p,2)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()==1 and tp or 1-tp
	local bm,bs=s.fullmzone(p),s.fullszone(p)
	local zop=0
	if bm and bs then
		zop=aux.SelectFromOptions(tp,
			{bm,aux.Stringid(id,4),1},
			{bs,aux.Stringid(id,5),2})
	elseif bm then zop=1
	elseif bs then zop=2
	else return end
	local g=Group.CreateGroup()
	if zop==1 then
		g=Duel.GetMatchingGroup(s.zonefilter,p,LOCATION_MZONE,0,nil)
	else
		g=Duel.GetMatchingGroup(s.zonefilter,p,LOCATION_SZONE,0,nil)
	end
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)==5 then
		Duel.BreakEffect()
		Duel.Draw(p,2,REASON_EFFECT)
	end
end
