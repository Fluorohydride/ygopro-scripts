--竜輝巧－アルζ
---@param c Card
function c96026108.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c96026108.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=aux.AddDrytronSpSummonEffect(c,c96026108.extraop)
	e2:SetDescription(aux.Stringid(96026108,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetCountLimit(1,96026108)
end
function c96026108.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x154)
end
function c96026108.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c96026108.extraop(e,tp)
	local g=Duel.GetMatchingGroup(c96026108.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(96026108,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
