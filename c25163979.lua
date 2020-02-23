--星遺物へ誘う悪夢
function c25163979.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c25163979.efilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25163979,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c25163979.mvtg)
	e3:SetOperation(c25163979.mvop)
	c:RegisterEffect(e3)
end
function c25163979.efilter(e,c)
	return c:GetMutualLinkedGroupCount()>0
end
function c25163979.mvfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x112)
end
function c25163979.mvfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x112) and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(c25163979.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function c25163979.mvfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0x112) and c:GetSequence()<5
end
function c25163979.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c25163979.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	local b2=Duel.IsExistingMatchingCard(c25163979.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(25163979,1),aux.Stringid(25163979,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(25163979,1))
	else op=Duel.SelectOption(tp,aux.Stringid(25163979,2))+1 end
	e:SetLabel(op)
end
function c25163979.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25163979,3))
		local g=Duel.SelectMatchingCard(tp,c25163979.mvfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(g:GetFirst(),nseq)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g1=Duel.SelectMatchingCard(tp,c25163979.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.HintSelection(g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g2=Duel.SelectMatchingCard(tp,c25163979.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.SwapSequence(tc1,tc2)
	end
end
