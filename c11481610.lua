--EMポップアップ
function c11481610.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11481610+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11481610.cost)
	e1:SetTarget(c11481610.target)
	e1:SetOperation(c11481610.activate)
	c:RegisterEffect(e1)
end
function c11481610.cfilter(c,e,tp,lsc,rsc)
	local lv=c:GetLevel()
	return (c:IsSetCard(0x9f,0x99) or (c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and lv>0 and lv>lsc and lv<rsc
end
function c11481610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	local ct=1
	for i=2,3 do
		if Duel.IsPlayerCanDraw(tp,i) then ct=i end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,ct,nil)
	e:SetLabel(Duel.SendtoGrave(sg,REASON_COST))
end
function c11481610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function c11481610.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.Draw(p,d,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local res=false
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if ct>0 and ft>0 and lc and rc then
		local lsc=lc:GetLeftScale()
		local rsc=rc:GetRightScale()
		if lsc>rsc then lsc,rsc=rsc,lsc end
		if Duel.IsExistingMatchingCard(c11481610.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,lsc,rsc) and Duel.SelectYesNo(tp,aux.Stringid(11481610,0)) then
			Duel.BreakEffect()
			ct=math.min(ct,ft)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
			local g=Duel.GetMatchingGroup(c11481610.cfilter,tp,LOCATION_HAND,0,nil,e,tp,lsc,rsc)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
			res=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if not res then
		local lp=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.SetLP(tp,Duel.GetLP(tp)-lp*1000)
	end
end
