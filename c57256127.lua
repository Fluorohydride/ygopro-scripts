--Shipping Archfiend
local s,id,o=GetID()
function s.initial_effect(c)
	--change race/attribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.artg)
	e1:SetOperation(s.arop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.arfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function s.gcheck(g)
	local att=ATTRIBUTE_ALL
	local race=ATTRIBUTE_ALL
	for tc in aux.Next(g) do
		att=bit.band(att,tc:GetAttribute())
		race=bit.band(race,tc:GetRace())
	end
	return att~=ATTRIBUTE_ALL or race~=RACE_ALL
end
function s.chkcfilter(c,op,val)
	if op==1 then
		return not c:IsAttribute(val)
	else
		return not c:IsRace(val)
	end
end
function s.artg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetMatchingGroup(s.arfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chkc then
		local op,val=e:GetLabel()
		return chkc:IsType(TYPE_MONSTER) and chkc:IsFaceup() and s.chkcfilter(chkc,op,val)
	end
	if chk==0 then return tg:CheckSubGroup(s.gcheck,1,99) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=tg:SelectSubGroup(tp,s.gcheck,false,1,99)
	local att=ATTRIBUTE_ALL
	local race=ATTRIBUTE_ALL
	for tc in aux.Next(g) do
		att=bit.band(att,tc:GetAttribute())
		race=bit.band(race,tc:GetRace())
	end
	local b1=att~=ATTRIBUTE_ALL
	local b2=race~=RACE_ALL
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,2),1},
			{b2,aux.Stringid(id,3),2})
	local var=0
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		var=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-att)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		var=Duel.AnnounceRace(tp,1,RACE_ALL-race)
	end
	e:SetLabel(op,var)
	Duel.SetTargetCard(g)
end
function s.arop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	local c=e:GetHandler()
	local op,val=e:GetLabel()
	if op==1 then
		for tc in aux.Next(tg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	elseif op==2 then
		for tc in aux.Next(tg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.thfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function s.fselect(g)
	return aux.SameValueCheck(g,Card.GetAttribute) and aux.SameValueCheck(g,Card.GetRace) and g:GetClassCount(Card.GetControler)==2
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(s.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
