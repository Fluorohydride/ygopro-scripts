--ドロドロゴン
function c84040113.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--fusion (s)
	local e1=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_MZONE,
		include_this_card=true,
		reg=false
	})
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,84040113)
	e1:SetCondition(c84040113.spcon)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c84040113.subcon)
	c:RegisterEffect(e2)
end
function c84040113.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c84040113.spcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
