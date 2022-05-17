--イモータル・ドラゴン
local s,id,o=GetID()
function c91575236.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,91575236)
	e1:SetTarget(c91575236.tgtg)
	e1:SetOperation(c91575236.tgop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,91575236+o)
	e2:SetCondition(c91575236.spcon)
	e2:SetTarget(c91575236.sptg)
	e2:SetOperation(c91575236.spop)
	c:RegisterEffect(e2)
end
function c91575236.tgfilter(c,lv,olv)
	local clv=c:GetOriginalLevel()
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave() and clv~=olv and math.abs(clv-olv)~=lv
end
function c91575236.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		return c:IsLevelAbove(0)
			and Duel.IsExistingMatchingCard(c91575236.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel(),c:GetOriginalLevel())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c91575236.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c91575236.tgfilter,tp,LOCATION_DECK,0,1,1,nil,c:GetLevel(),c:GetOriginalLevel())
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(math.abs(c:GetOriginalLevel()-tc:GetOriginalLevel()))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c91575236.cfilter(c,tp)
	return c:GetPreviousRaceOnField()&RACE_ZOMBIE~=0 and c:IsPreviousControler(tp)
end
function c91575236.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c91575236.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c91575236.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c91575236.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end
