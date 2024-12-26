--天魔神 シドヘルズ
---@param c Card
function c15792576.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--option
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15792576,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c15792576.opcon)
	e1:SetTarget(c15792576.optg)
	e1:SetOperation(c15792576.opop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c15792576.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c15792576.chkfilter(c,rac,att)
	return c:IsRace(rac) and c:IsAttribute(att)
end
function c15792576.valcheck(e,c)
	local label=0
	local g=c:GetMaterial()
	if g:IsExists(c15792576.chkfilter,1,nil,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		label=label+1
	end
	if g:IsExists(c15792576.chkfilter,1,nil,RACE_FIEND,ATTRIBUTE_DARK) then
		label=label+2
	end
	e:GetLabelObject():SetLabel(label)
end
function c15792576.opcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and e:GetLabel()>0
end
function c15792576.thfilter(c)
	return (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)) or (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)) and c:IsAbleToHand()
end
function c15792576.tgfilter(c)
	return (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)) or (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)) and c:IsAbleToGrave()
end
function c15792576.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local label=e:GetLabel()
	if chk==0 then
		if label==1 then
			return Duel.IsExistingMatchingCard(c15792576.thfilter,tp,LOCATION_DECK,0,1,nil)
		elseif label==2 then
			return Duel.IsExistingMatchingCard(c15792576.tgfilter,tp,LOCATION_DECK,0,1,nil)
		else
			return true
		end
	end
	e:SetLabel(label)
	if label==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(15792576,1))
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif label==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(15792576,2))
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c15792576.opop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if label==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c15792576.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	elseif label==2 then
		local g=Duel.GetMatchingGroup(c15792576.tgfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=g:SelectSubGroup(tp,aux.drccheck,false,1,2)
		if g2 then
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	end
end
