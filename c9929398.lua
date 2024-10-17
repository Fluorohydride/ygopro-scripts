--BF－朧影のゴウフウ
---@param c Card
function c9929398.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9929398.spcon)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9929398,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9929398.tkncon)
	e2:SetTarget(c9929398.tkntg)
	e2:SetOperation(c9929398.tknop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9929398,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c9929398.target)
	e3:SetOperation(c9929398.operation)
	c:RegisterEffect(e3)
end
function c9929398.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c9929398.tkncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c9929398.tkntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9929399,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_WINDBEAST,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c9929398.tknop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9929399,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_WINDBEAST,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,9929399)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			token:RegisterEffect(e3,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c9929398.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(0)
end
function c9929398.spfilter(c,e,tp,ct)
	local rlv=c:GetLevel()-e:GetHandler():GetLevel()
	if rlv<1 then return false end
	local rg=Duel.GetMatchingGroup(c9929398.cfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x33) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,ct,63)
end
function c9929398.chkcfilter(c,e,tp,lv)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x33)
		and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9929398.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return c9929398.chkcfilter(chkc,e,tp,e:GetLabel()) end
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c9929398.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9929398.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ct)
	local rlv=g:GetFirst():GetLevel()-e:GetHandler():GetLevel()
	local rg=Duel.GetMatchingGroup(c9929398.cfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,ct,63)
	g2:AddCard(e:GetHandler())
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c9929398.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
