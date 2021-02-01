--ミュステリオンの竜冠
function c13735899.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),true)
	--cannot be fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--ATK down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(c13735899.atkval)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13735899,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,13735899)
	e3:SetTarget(c13735899.remtg)
	e3:SetOperation(c13735899.remop)
	c:RegisterEffect(e3)
end
function c13735899.atkval(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_REMOVED,0)*-100
end
function c13735899.cfilter(c,e,rc)
	return c:IsFaceup() and (c:GetOriginalRace()==rc:GetOriginalRace() or c==rc)
		and c:IsCanBeEffectTarget(e) and c:IsAbleToRemove()
end
function c13735899.rmfilter(c,tc)
	return c:IsFaceup() and c:GetOriginalRace()==tc:GetOriginalRace()
end
function c13735899.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c13735899.cfilter(chkc,e,re:GetHandler()) end
	if chk==0 then return re and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and eg:IsExists(c13735899.cfilter,1,nil,e,re:GetHandler()) end
	local tc=eg:GetFirst()
	if #eg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=eg:FilterSelect(tp,c13735899.cfilter,1,1,nil,e,re:GetHandler()):GetFirst()
	end
	Duel.SetTargetCard(tc)
	local g=Duel.GetMatchingGroup(c13735899.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc)
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c13735899.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Group.FromCards(tc)
		if tc:IsFaceup() then
			g=g+Duel.GetMatchingGroup(c13735899.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc)
		end
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
