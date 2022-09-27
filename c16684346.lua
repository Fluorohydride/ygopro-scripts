--プロキシー・ホース
function c16684346.initial_effect(c)
	--extra hand link
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16684346,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERSE))
	e1:SetCountLimit(1,16684346)
	e1:SetValue(c16684346.matval)
	c:RegisterEffect(e1)
	--to extra deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16684346,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16684347)
	e2:SetCondition(c16684346.tdcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16684346.tdtg)
	e2:SetOperation(c16684346.tdop)
	c:RegisterEffect(e2)
end
function c16684346.exmatcheck(c,lc,tp)
	if not c:IsLocation(LOCATION_HAND) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(16684346) then return false end
	end
	return true
end
function c16684346.matval(e,lc,mg,c,tp)
	if not lc:IsRace(RACE_CYBERSE) then return false,nil end
	return true,not mg or mg:IsContains(e:GetHandler()) and not mg:IsExists(c16684346.exmatcheck,1,nil,lc,tp)
end
function c16684346.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c16684346.tdfilter(c,e)
	return c:IsType(TYPE_LINK) and c:IsAbleToExtra() and c:IsCanBeEffectTarget(e)
end
function c16684346.fselect(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_CYBERSE)
end
function c16684346.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g1=Duel.GetMatchingGroup(c16684346.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
	if chk==0 then return g1:CheckSubGroup(c16684346.fselect,2,2) end
	local g2=Duel.GetMatchingGroup(c16684346.tdfilter,tp,LOCATION_GRAVE,0,nil,e)
	local sg=g2:SelectSubGroup(tp,c16684346.fselect,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,sg,2,0,0)
end
function c16684346.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
