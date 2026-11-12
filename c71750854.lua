--ボンバー・プレイス
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function s.descon1(tp)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsLevelBelow),tp,LOCATION_MZONE,0,nil,6)
	local lvc=0
	for tc in aux.Next(g) do
		lvc=lvc|(1<<(tc:GetLevel()-1))
	end
	return lvc==0x3f
end
function s.tgfilter1(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1)
		and Duel.IsExistingMatchingCard(s.desfilter1,tp,0,LOCATION_MZONE,1,c,c:GetLevel())
end
function s.desfilter1(c,lv)
	return c:IsFaceup() and (c:IsLevel(lv) or c:IsRank(lv) or c:IsLink(lv))
end
function s.tgfilter2(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1)
		and c:GetColumnGroup():FilterCount(s.desfilter2,nil,tp,c:GetLevel())>0
end
function s.desfilter2(c,tp,lv)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsControler(1-tp) and (c:IsLevel(lv) or c:IsRank(lv) or c:IsLink(lv))
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=s.descon1(tp) and Duel.IsExistingMatchingCard(s.tgfilter1,tp,0,LOCATION_MZONE,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local label=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0),1},
		{b2,aux.Stringid(id,1),2})
	e:SetLabel(label)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if label==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter1,tp,0,LOCATION_MZONE,1,1,nil,tp)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local sg=Duel.GetMatchingGroup(s.desfilter1,tp,0,LOCATION_MZONE,g,g:GetFirst():GetLevel())
			Duel.Destroy(sg,POS_FACEUP,REASON_EFFECT)
		end
	elseif label==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.HintSelection(g)
			local dg=tc:GetColumnGroup():Filter(s.desfilter2,nil,tp,tc:GetLevel())
			Duel.Destroy(dg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
