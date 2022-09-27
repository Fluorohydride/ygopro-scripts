--マテリアクトル・ギガドラ
function c33008376.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33008376,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33008376)
	e1:SetCost(c33008376.spcost)
	e1:SetTarget(c33008376.sptg)
	e1:SetOperation(c33008376.spop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c33008376.splimit)
	c:RegisterEffect(e2)
end
function c33008376.costfilter(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c33008376.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,c:IsType(TYPE_NORMAL))
end
function c33008376.spfilter(c,e,tp,normal)
	return (normal and c:IsSetCard(0x160) or c:IsLevel(3) and c:IsType(TYPE_NORMAL)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33008376.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c33008376.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(tp,c33008376.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if sg:GetFirst():IsType(TYPE_NORMAL) then
		e:SetLabel(100,1)
	else
		e:SetLabel(100,0)
	end
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c33008376.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check,label=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,0)
		return check==100 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	e:SetLabel(0,label)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c33008376.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local check,label=e:GetLabel()
	local normal=label==1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33008376.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,normal)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33008376.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
