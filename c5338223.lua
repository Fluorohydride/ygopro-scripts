--強制進化
---@param c Card
function c5338223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c5338223.cost)
	e1:SetTarget(c5338223.target)
	e1:SetOperation(c5338223.activate)
	c:RegisterEffect(e1)
end
function c5338223.cfilter(c,ft,tp)
	return c:IsSetCard(0x304e)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c5338223.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c5338223.cfilter,1,nil,ft,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c5338223.cfilter,1,1,nil,ft,tp)
	Duel.Release(rg,REASON_COST)
end
function c5338223.spfilter(c,e,tp)
	return c:IsSetCard(0x604e) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_EVOLTILE,tp,false,false)
end
function c5338223.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c5338223.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c5338223.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		end
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c5338223.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c5338223.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_VALUE_EVOLTILE,tp,tp,false,false,POS_FACEUP)
	end
end
